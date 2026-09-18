import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/tables.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/link_repository.dart';
import 'package:alveo/data/repositories/medication_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/repositories/tag_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/repositories/thought_record_repository.dart';
import 'package:alveo/domain/emotions/emotion_input.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every write moves updatedAt forward — the column is only worth carrying if
/// the repositories keep it true.
///
/// Parent tables are edited in place, so each edit must stamp the row. The
/// child and join tables (emotions, tags, links, distortions, dose logs) are
/// never updated in place: they are inserted, or deleted and re-inserted as a
/// set. A new row is stamped by the column default; a deleted one leaves no
/// row to stamp, so the change has to show on the parent instead. Both halves
/// are checked here, for every table v9 gave the column to plus
/// journal_entries, which always had it.
void main() {
  late AppDatabase db;
  final long = DateTime(2020);

  setUp(() => db = AppDatabase.forTesting());
  tearDown(() => db.close());

  Future<void> backdate(TableInfo table, String idColumn, String id) =>
      db.customUpdate(
        'UPDATE ${table.actualTableName} SET updated_at = ? '
        'WHERE $idColumn = ?',
        variables: [
          Variable(long.millisecondsSinceEpoch ~/ 1000),
          Variable(id),
        ],
      );

  Future<DateTime> updatedAtOf(TableInfo table, String idColumn, String id) =>
      db
          .customSelect(
            'SELECT updated_at FROM ${table.actualTableName} '
            'WHERE $idColumn = ?',
            variables: [Variable(id)],
          )
          .getSingle()
          .then(
            (row) => DateTime.fromMillisecondsSinceEpoch(
              row.read<int>('updated_at') * 1000,
            ),
          );

  test('a check-in edit stamps the entry', () async {
    final repo = DriftMoodRepository(db);
    final id = await repo.add(mood: 3, occurredAt: DateTime(2026, 1, 1));
    await backdate(db.moodEntries, 'id', id);
    await repo.update(id: id, mood: 5);
    expect((await updatedAtOf(db.moodEntries, 'id', id)).isAfter(long), isTrue);
  });

  test(
    'a task edit, a status change and closing it all stamp the task',
    () async {
      final repo = DriftTaskRepository(db);
      final id = await repo.create(title: 'Breathe');
      for (final write in [
        () => repo.update(
          id: id,
          title: 'Breathe out',
          status: TaskStatus.pending,
        ),
        () => repo.setStatus(id, TaskStatus.inProgress),
        () => repo.close(id, closingNote: 'went fine'),
      ]) {
        await backdate(db.tasks, 'id', id);
        await write();
        expect((await updatedAtOf(db.tasks, 'id', id)).isAfter(long), isTrue);
      }
    },
  );

  test('a session edit stamps the session', () async {
    final repo = DriftSessionRepository(db);
    final id = await repo.create(scheduledFor: DateTime(2026, 2, 2));
    await backdate(db.sessions, 'id', id);
    await repo.update(id: id, scheduledFor: DateTime(2026, 2, 3));
    expect((await updatedAtOf(db.sessions, 'id', id)).isAfter(long), isTrue);
  });

  test('a medication edit stamps it', () async {
    final repo = DriftMedicationRepository(db);
    final id = await repo.create(name: 'Sertraline');
    await backdate(db.medications, 'id', id);
    await repo.update(id: id, name: 'Sertraline', active: false);
    expect((await updatedAtOf(db.medications, 'id', id)).isAfter(long), isTrue);
  });

  test('a thought-record edit stamps it', () async {
    final repo = DriftThoughtRecordRepository(db);
    final id = await repo.create(
      occurredAt: DateTime(2026, 3, 3),
      situation: 'meeting',
      automaticThought: 'they hate me',
    );
    await backdate(db.thoughtRecords, 'id', id);
    await repo.update(
      id: id,
      occurredAt: DateTime(2026, 3, 3),
      situation: 'meeting',
      automaticThought: 'maybe not',
    );
    expect(
      (await updatedAtOf(db.thoughtRecords, 'id', id)).isAfter(long),
      isTrue,
    );
  });

  test('a rewritten setting stamps the row', () async {
    final repo = DriftSettingsRepository(db);
    await repo.set('k', 'one');
    await backdate(db.appSettings, 'key', 'k');
    await repo.set('k', 'two');
    expect(
      (await updatedAtOf(db.appSettings, 'key', 'k')).isAfter(long),
      isTrue,
    );
  });

  Future<List<DateTime>> updatedAtsOf(String table) => db
      .customSelect('SELECT updated_at FROM $table')
      .get()
      .then(
        (rows) => [
          for (final row in rows)
            DateTime.fromMillisecondsSinceEpoch(
              row.read<int>('updated_at') * 1000,
            ),
        ],
      );

  test('a journal body edit stamps the entry', () async {
    final repo = DriftJournalRepository(db);
    final id = await repo.create(
      bodyMarkdown: 'one',
      entryDate: DateTime(2026, 1, 1),
    );
    await backdate(db.journalEntries, 'id', id);
    await repo.updateBody(id: id, bodyMarkdown: 'two');
    expect(
      (await updatedAtOf(db.journalEntries, 'id', id)).isAfter(long),
      isTrue,
    );
  });

  test(
    'replacing journal emotions stamps the entry and the new rows',
    () async {
      final repo = DriftJournalRepository(db);
      final id = await repo.create(
        bodyMarkdown: 'one',
        entryDate: DateTime(2026, 1, 1),
        emotions: const [EmotionInput(emotionKey: 'joy', intensity: 2)],
      );
      await backdate(db.journalEntries, 'id', id);
      await repo.replaceEmotions(id, const []);
      expect(
        (await updatedAtOf(db.journalEntries, 'id', id)).isAfter(long),
        isTrue,
        reason: 'the removed emotion leaves no row behind to carry the change',
      );

      await repo.replaceEmotions(id, const [
        EmotionInput(emotionKey: 'sadness', intensity: 1),
      ]);
      expect(
        (await updatedAtsOf('journal_entry_emotions')).single.isAfter(long),
        isTrue,
      );
    },
  );

  test('new mood emotions and tag links are stamped', () async {
    final tagId = await DriftTagRepository(db).findOrCreate('work');
    await DriftMoodRepository(db).add(
      mood: 3,
      occurredAt: DateTime(2026, 1, 1),
      emotions: const [EmotionInput(emotionKey: 'joy', intensity: 2)],
      tagIds: [tagId],
    );
    for (final table in ['tags', 'mood_entry_emotions', 'mood_entry_tags']) {
      expect((await updatedAtsOf(table)).single.isAfter(long), isTrue);
    }
  });

  test('new journal tag links are stamped', () async {
    final tagId = await DriftTagRepository(db).findOrCreate('work');
    await DriftJournalRepository(db).create(
      bodyMarkdown: 'one',
      entryDate: DateTime(2026, 1, 1),
      tagIds: [tagId],
    );
    expect(
      (await updatedAtsOf('journal_entry_tags')).single.isAfter(long),
      isTrue,
    );
  });

  test('linking and unlinking stamp the session', () async {
    final sessionId = await DriftSessionRepository(db)
        .create(scheduledFor: DateTime(2026, 2, 2));
    final links = DriftLinkRepository(db);

    await backdate(db.sessions, 'id', sessionId);
    await links.link(sessionId, LinkTargetType.task, 't1');
    expect(
      (await updatedAtOf(db.sessions, 'id', sessionId)).isAfter(long),
      isTrue,
    );
    expect((await updatedAtsOf('session_links')).single.isAfter(long), isTrue);

    await backdate(db.sessions, 'id', sessionId);
    await links.unlink(sessionId, LinkTargetType.task, 't1');
    expect(
      (await updatedAtOf(db.sessions, 'id', sessionId)).isAfter(long),
      isTrue,
      reason: 'the removed link leaves no row behind to carry the change',
    );

    await links.link(sessionId, LinkTargetType.task, 't1');
    await backdate(db.sessions, 'id', sessionId);
    await links.removeLinksTo(LinkTargetType.task, 't1');
    expect(
      (await updatedAtOf(db.sessions, 'id', sessionId)).isAfter(long),
      isTrue,
      reason: 'deleting the target unlinks it from the session',
    );
  });

  test('rewritten distortions are stamped', () async {
    final repo = DriftThoughtRecordRepository(db);
    final id = await repo.create(
      occurredAt: DateTime(2026, 3, 3),
      situation: 'meeting',
      automaticThought: 'they hate me',
    );
    await repo.update(
      id: id,
      occurredAt: DateTime(2026, 3, 3),
      situation: 'meeting',
      automaticThought: 'they hate me',
      distortions: {CognitiveDistortion.values.first},
    );
    expect(
      (await updatedAtsOf('thought_record_distortions')).single.isAfter(long),
      isTrue,
    );
  });

  test('a logged dose is stamped', () async {
    final repo = DriftMedicationRepository(db);
    final id = await repo.create(name: 'Sertraline');
    await repo.logDose(id, takenAt: DateTime(2026, 4, 4));
    expect(
      (await updatedAtsOf('medication_logs')).single.isAfter(long),
      isTrue,
    );
  });
}
