import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/all_records/text_record.dart';
import '../cbt/thought_record_providers.dart';
import '../journal/journal_providers.dart';
import '../sessions/session_providers.dart';
import '../tasks/task_providers.dart';

String _join(Iterable<String?> parts) => parts
    .whereType<String>()
    .map((p) => p.trim())
    .where((p) => p.isNotEmpty)
    .join('\n\n');

/// Every text the user has written, newest first, gathered from journal
/// entries, session notes, thought records, tasks and check-in notes.
///
/// Rebuilds whenever any of the source lists is invalidated.
final allTextRecordsProvider = FutureProvider<List<TextRecord>>((ref) async {
  final journals = await ref.watch(journalListProvider.future);
  final sessions = await ref.watch(sessionListProvider.future);
  final tasks = await ref.watch(taskListProvider.future);
  final thoughtRecords = await ref.watch(thoughtRecordListProvider.future);
  final moods = await ref.watch(moodEntriesProvider.future);

  final records = <TextRecord>[
    for (final j in journals)
      TextRecord(
        kind: TextRecordKind.journal,
        when: j.entryDate,
        title: j.title,
        body: j.bodyMarkdown,
      ),
    for (final s in sessions)
      TextRecord(
        kind: TextRecordKind.session,
        when: s.scheduledFor,
        body: _join([s.agendaMarkdown, s.notesMarkdown, s.takeawaysMarkdown]),
      ),
    for (final t in tasks)
      TextRecord(
        kind: TextRecordKind.task,
        when: t.createdAt,
        title: t.title,
        body: _join([t.descriptionMarkdown, t.closingNote]),
      ),
    for (final r in thoughtRecords)
      TextRecord(
        kind: TextRecordKind.thoughtRecord,
        when: r.occurredAt,
        title: r.situation,
        body: _join([r.automaticThought, r.alternativeThought]),
      ),
    for (final m in moods)
      TextRecord(
        kind: TextRecordKind.mood,
        when: m.occurredAt,
        body: m.note ?? '',
      ),
  ];

  return sortedTextRecords(records);
});
