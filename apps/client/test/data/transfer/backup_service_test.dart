import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/link_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/transfer/backup_service.dart';
import 'package:alveo/domain/links/link_target_type.dart';
import 'package:alveo/domain/transfer/import_report.dart';

Future<AppDatabase> _populatedSource() async {
  final db = AppDatabase.forTesting();
  await db
      .into(db.tags)
      .insert(TagsCompanion.insert(id: 'tag-work', name: 'work'));
  await MoodRepository(db).add(
    mood: 4,
    occurredAt: DateTime(2026, 8, 20, 9),
    note: 'ok',
    emotions: const [EmotionInput(emotionKey: 'joy', intensity: 3)],
    tagIds: ['tag-work'],
    id: 'mood-1',
  );
  await JournalRepository(db).create(
    bodyMarkdown: '# hi',
    entryDate: DateTime(2026, 8, 20),
    title: 'Notes',
    id: 'jrnl-1',
  );
  await TaskRepository(db).create(title: 'Breathe', id: 'task-1');
  await SessionRepository(db).create(
    scheduledFor: DateTime(2026, 9, 1, 10),
    agendaMarkdown: 'prep',
    id: 'sess-1',
  );
  await LinkRepository(db).link('sess-1', LinkTargetType.task, 'task-1');
  return db;
}

void main() {
  // These tests legitimately open two in-memory databases at once.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test(
    'export then import into a fresh database carries everything over',
    () async {
      final source = await _populatedSource();
      final json = await BackupService(source).exportToJson();
      addTearDown(source.close);

      final target = AppDatabase.forTesting();
      addTearDown(target.close);
      final report = await BackupService(target).importFromJson(json);

      expect(report.tables['tags']!.inserted, 1);
      expect(report.tables['moodEntries']!.inserted, 1);
      expect(report.tables['moodEntryEmotions']!.inserted, 1);
      expect(report.tables['moodEntryTags']!.inserted, 1);
      expect(report.tables['journalEntries']!.inserted, 1);
      expect(report.tables['tasks']!.inserted, 1);
      expect(report.tables['sessions']!.inserted, 1);
      expect(report.tables['sessionLinks']!.inserted, 1);

      expect((await MoodRepository(target).getAll()).single.note, 'ok');
      expect(await MoodRepository(target).emotionsFor('mood-1'), hasLength(1));
      expect(
        (await SessionRepository(target).getAll()).single.agendaMarkdown,
        'prep',
      );
      expect(await LinkRepository(target).linkedItems('sess-1'), hasLength(1));
    },
  );

  test('re-importing the same backup skips everything', () async {
    final source = await _populatedSource();
    addTearDown(source.close);
    final json = await BackupService(source).exportToJson();

    final target = AppDatabase.forTesting();
    addTearDown(target.close);
    await BackupService(target).importFromJson(json);
    final again = await BackupService(target).importFromJson(json);

    expect(again.totalInserted, 0);
    expect(again.tables['moodEntries']!.skipped, 1);
    expect(again.tables['sessionLinks']!.skipped, 1);
  });

  test('a tag that already exists by name is reused, not duplicated', () async {
    final source = await _populatedSource();
    addTearDown(source.close);
    final json = await BackupService(source).exportToJson();

    final target = AppDatabase.forTesting();
    addTearDown(target.close);
    await target
        .into(target.tags)
        .insert(TagsCompanion.insert(id: 'local-work', name: 'work'));

    final report = await BackupService(target).importFromJson(json);

    expect(report.tables['tags']!.inserted, 0);
    expect(report.tables['tags']!.skipped, 1);

    // The imported mood_entry_tag now points at the local tag id.
    final joinRows = await target
        .customSelect('SELECT * FROM mood_entry_tags')
        .get();
    expect(joinRows, hasLength(1));
    expect(joinRows.single.data['tag_id'], 'local-work');
  });

  test('a backup from a newer schema version is refused', () async {
    final target = AppDatabase.forTesting();
    addTearDown(target.close);

    expect(
      () => BackupService(target).importFromJson(
        '{"format":"alveo-export","version":1,'
        '"schemaVersion":999,"data":{}}',
      ),
      throwsA(isA<ImportException>()),
    );
  });

  test('a non-backup file is refused', () async {
    final target = AppDatabase.forTesting();
    addTearDown(target.close);

    expect(
      () => BackupService(target).importFromJson('just some text'),
      throwsA(isA<ImportException>()),
    );
  });
}
