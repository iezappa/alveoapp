import 'package:drift/drift.dart';

import '../local/database.dart';

/// The columns of the CSV export, one row per record of any kind.
const csvHeader = ['type', 'date', 'title', 'text', 'details'];

/// The values of the `type` column, in the order records are written.
const csvRecordTypes = [
  'check-in',
  'journal',
  'task',
  'session',
  'thought record',
  'medication',
  'medication dose',
];

/// Quotes [value] per RFC 4180 when needed, and defuses leading characters a
/// spreadsheet would run as a formula — including a leading tab or carriage
/// return, which spreadsheets skip before deciding.
String csvField(String value) {
  var v = value;
  if (v.isNotEmpty && '=+-@\t\r'.contains(v[0])) v = "'$v";
  if (v.contains(RegExp(r'[",\r\n]'))) {
    return '"${v.replaceAll('"', '""')}"';
  }
  return v;
}

/// A human-readable export for reading in a spreadsheet. It is not a backup:
/// it cannot be imported, and it leaves out ids and settings. The JSON export
/// is the backup.
class CsvExportService {
  CsvExportService(this._db);

  final AppDatabase _db;

  static String _date(DateTime? d) {
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    final l = d.toLocal();
    return '${l.year}-${two(l.month)}-${two(l.day)} '
        '${two(l.hour)}:${two(l.minute)}';
  }

  static String _join(Iterable<String?> parts) =>
      parts.whereType<String>().where((p) => p.isNotEmpty).join('; ');

  Future<String> exportToCsv() async {
    final rows = <List<String>>[csvHeader];
    void add(
      String type,
      DateTime? date,
      String? title,
      String? text,
      String details,
    ) => rows.add([type, _date(date), title ?? '', text ?? '', details]);

    final tagNames = {
      for (final t in await _db.select(_db.tags).get()) t.id: t.name,
    };

    final moodEmotions = await _db.select(_db.moodEntryEmotions).get();
    final moodTags = await _db.select(_db.moodEntryTags).get();
    final moods = await (_db.select(
      _db.moodEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])).get();
    for (final m in moods) {
      final emotions = moodEmotions
          .where((e) => e.moodEntryId == m.id)
          .map((e) => '${e.emotionKey} ${e.intensity}');
      final tags = moodTags
          .where((t) => t.moodEntryId == m.id)
          .map((t) => tagNames[t.tagId]);
      add(
        'check-in',
        m.occurredAt,
        '${m.mood}/5',
        m.note,
        _join([
          if (emotions.isNotEmpty) 'emotions: ${emotions.join(', ')}',
          if (tags.isNotEmpty) 'tags: ${tags.whereType<String>().join(', ')}',
        ]),
      );
    }

    final journalTags = await _db.select(_db.journalEntryTags).get();
    final journalEmotions = await _db.select(_db.journalEntryEmotions).get();
    final journal = await (_db.select(
      _db.journalEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.entryDate)])).get();
    for (final j in journal) {
      final emotions = journalEmotions
          .where((e) => e.journalEntryId == j.id)
          .map((e) => '${e.emotionKey} ${e.intensity}');
      final tags = journalTags
          .where((t) => t.journalEntryId == j.id)
          .map((t) => tagNames[t.tagId]);
      add(
        'journal',
        j.entryDate,
        j.title,
        j.bodyMarkdown,
        _join([
          'notebook: ${j.section.name}',
          if (j.isMonthlyReview) 'monthly review',
          if (emotions.isNotEmpty) 'emotions: ${emotions.join(', ')}',
          if (tags.isNotEmpty) 'tags: ${tags.whereType<String>().join(', ')}',
        ]),
      );
    }

    final tasks = await (_db.select(
      _db.tasks,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    for (final t in tasks) {
      add(
        'task',
        t.dueDate ?? t.createdAt,
        t.title,
        t.descriptionMarkdown,
        _join([
          'status: ${t.status.name}',
          if (t.completedAt != null) 'completed: ${_date(t.completedAt)}',
          if (t.closingNote != null) 'closing note: ${t.closingNote}',
        ]),
      );
    }

    final sessions = await (_db.select(
      _db.sessions,
    )..orderBy([(t) => OrderingTerm.asc(t.scheduledFor)])).get();
    for (final s in sessions) {
      add(
        'session',
        s.scheduledFor,
        '',
        [
          if (s.agendaMarkdown?.isNotEmpty ?? false)
            'Agenda:\n${s.agendaMarkdown}',
          if (s.notesMarkdown?.isNotEmpty ?? false)
            'Notes:\n${s.notesMarkdown}',
          if (s.takeawaysMarkdown?.isNotEmpty ?? false)
            'Takeaways:\n${s.takeawaysMarkdown}',
        ].join('\n\n'),
        '',
      );
    }

    final distortions = await _db.select(_db.thoughtRecordDistortions).get();
    final records = await (_db.select(
      _db.thoughtRecords,
    )..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])).get();
    for (final r in records) {
      final named = distortions
          .where((d) => d.recordId == r.id)
          .map((d) => d.distortion.name);
      add(
        'thought record',
        r.occurredAt,
        r.situation,
        _join([
          'thought: ${r.automaticThought}',
          if (r.alternativeThought != null)
            'alternative: ${r.alternativeThought}',
        ]),
        _join([
          if (r.emotionLabel != null) 'emotion: ${r.emotionLabel}',
          if (r.beliefBefore != null) 'belief before: ${r.beliefBefore}',
          if (r.beliefAfter != null) 'belief after: ${r.beliefAfter}',
          if (r.emotionIntensityBefore != null)
            'intensity before: ${r.emotionIntensityBefore}',
          if (r.emotionIntensityAfter != null)
            'intensity after: ${r.emotionIntensityAfter}',
          if (named.isNotEmpty) 'distortions: ${named.join(', ')}',
        ]),
      );
    }

    final meds = await _db.select(_db.medications).get();
    final medName = {for (final m in meds) m.id: m.name};
    for (final m in meds) {
      add(
        'medication',
        m.createdAt,
        m.name,
        m.scheduleNote,
        _join([
          if (m.dose != null) 'dose: ${m.dose}',
          m.active ? 'active' : 'inactive',
        ]),
      );
    }
    final logs = await (_db.select(
      _db.medicationLogs,
    )..orderBy([(t) => OrderingTerm.asc(t.takenAt)])).get();
    for (final l in logs) {
      add('medication dose', l.takenAt, medName[l.medicationId], '', '');
    }

    final body = rows.map((r) => r.map(csvField).join(',')).join('\r\n');
    return '﻿$body\r\n';
  }
}
