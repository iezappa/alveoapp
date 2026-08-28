import 'package:drift/drift.dart';

import '../../domain/export/daily_markdown.dart';
import '../../domain/session/pre_session_summary.dart';
import '../local/database.dart';
import '../local/tables.dart';

/// Gathers everything logged on a given day and renders it to Markdown.
class ExportService {
  ExportService(this._db);

  final AppDatabase _db;

  /// Collects the day's records into a framework-free [DailyExport].
  Future<DailyExport> buildDailyExport(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    bool inDay(DateTime? t) =>
        t != null && !t.isBefore(start) && t.isBefore(end);

    // Moods (by when the feeling happened) + their emotions.
    final moodRows =
        await (_db.select(_db.moodEntries)
              ..where(
                (t) =>
                    t.occurredAt.isBiggerOrEqualValue(start) &
                    t.occurredAt.isSmallerThanValue(end),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
            .get();

    final emotionsByMood = <String, List<DayEmotion>>{};
    if (moodRows.isNotEmpty) {
      final ids = moodRows.map((m) => m.id).toList();
      final emotionRows = await (_db.select(
        _db.moodEntryEmotions,
      )..where((t) => t.moodEntryId.isIn(ids))).get();
      for (final e in emotionRows) {
        emotionsByMood
            .putIfAbsent(e.moodEntryId, () => [])
            .add(DayEmotion(key: e.emotionKey, intensity: e.intensity));
      }
    }

    final moods = [
      for (final m in moodRows)
        DayMoodEntry(
          occurredAt: m.occurredAt,
          mood: m.mood,
          note: m.note,
          emotions: emotionsByMood[m.id] ?? const [],
        ),
    ];

    // Journal entries filed under this day.
    final journalRows =
        await (_db.select(_db.journalEntries)
              ..where(
                (t) =>
                    t.entryDate.isBiggerOrEqualValue(start) &
                    t.entryDate.isSmallerThanValue(end),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();

    final journals = [
      for (final j in journalRows)
        DayJournalEntry(
          createdAt: j.createdAt,
          bodyMarkdown: j.bodyMarkdown,
          title: j.title,
        ),
    ];

    // Tasks created or completed on this day.
    final taskRows = await (_db.select(
      _db.tasks,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    final tasks = [
      for (final t in taskRows)
        if (inDay(t.createdAt) || inDay(t.completedAt))
          DayTask(
            title: t.title,
            done: t.status == TaskStatus.done,
            closingNote: t.closingNote,
          ),
    ];

    return DailyExport(
      day: start,
      moods: moods,
      journals: journals,
      tasks: tasks,
    );
  }

  Future<String> buildDailyMarkdown(
    DateTime day, {
    String Function(String emotionKey)? emotionLabel,
  }) async {
    final data = await buildDailyExport(day);
    return renderDailyMarkdown(data, emotionLabel: emotionLabel);
  }

  /// Gathers everything logged in the half-open range `[from, to)`.
  Future<PreSessionActivity> buildRangeActivity(
    DateTime from,
    DateTime to,
  ) async {
    bool inRange(DateTime? t) =>
        t != null && !t.isBefore(from) && t.isBefore(to);

    final moodRows =
        await (_db.select(_db.moodEntries)
              ..where(
                (t) =>
                    t.occurredAt.isBiggerOrEqualValue(from) &
                    t.occurredAt.isSmallerThanValue(to),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
            .get();

    final emotionsByMood = <String, List<DayEmotion>>{};
    if (moodRows.isNotEmpty) {
      final ids = moodRows.map((m) => m.id).toList();
      final emotionRows = await (_db.select(
        _db.moodEntryEmotions,
      )..where((t) => t.moodEntryId.isIn(ids))).get();
      for (final e in emotionRows) {
        emotionsByMood
            .putIfAbsent(e.moodEntryId, () => [])
            .add(DayEmotion(key: e.emotionKey, intensity: e.intensity));
      }
    }
    final moods = [
      for (final m in moodRows)
        DayMoodEntry(
          occurredAt: m.occurredAt,
          mood: m.mood,
          note: m.note,
          emotions: emotionsByMood[m.id] ?? const [],
        ),
    ];

    final journalRows =
        await (_db.select(_db.journalEntries)
              ..where(
                (t) =>
                    t.entryDate.isBiggerOrEqualValue(from) &
                    t.entryDate.isSmallerThanValue(to),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    final journals = [
      for (final j in journalRows)
        DayJournalEntry(
          createdAt: j.createdAt,
          bodyMarkdown: j.bodyMarkdown,
          title: j.title,
        ),
    ];

    final taskRows = await (_db.select(
      _db.tasks,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    final tasks = [
      for (final t in taskRows)
        if (inRange(t.createdAt) || inRange(t.completedAt))
          DayTask(
            title: t.title,
            done: t.status == TaskStatus.done,
            closingNote: t.closingNote,
          ),
    ];

    return PreSessionActivity(
      from: from,
      to: to,
      moods: moods,
      journals: journals,
      tasks: tasks,
    );
  }

  Future<String> buildPreSessionSummary(
    DateTime from,
    DateTime to, {
    String Function(String emotionKey)? emotionLabel,
  }) async {
    final activity = await buildRangeActivity(from, to);
    return renderPreSessionSummary(activity, emotionLabel: emotionLabel);
  }
}
