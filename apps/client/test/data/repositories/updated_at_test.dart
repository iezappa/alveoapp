import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/tables.dart';
import 'package:alveo/data/repositories/medication_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/repositories/thought_record_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every write moves updatedAt forward — the column is only worth carrying if
/// the repositories keep it true.
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
}
