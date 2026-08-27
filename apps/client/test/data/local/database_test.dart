import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/local/tables.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting());
  tearDown(() => db.close());

  test('creates every Fase 1 table', () async {
    final rows = await db
        .customSelect(
          "SELECT name FROM sqlite_master "
          "WHERE type='table' AND name NOT LIKE 'sqlite_%'",
        )
        .get();
    final names = rows.map((r) => r.read<String>('name')).toSet();

    expect(
      names,
      containsAll([
        'mood_entries',
        'mood_entry_emotions',
        'journal_entries',
        'tasks',
        'tags',
        'mood_entry_tags',
        'journal_entry_tags',
      ]),
    );
  });

  test('foreign keys are enforced', () async {
    await db.customSelect('SELECT 1').get(); // force beforeOpen (PRAGMA)

    expect(
      () => db.into(db.moodEntryEmotions).insert(
            MoodEntryEmotionsCompanion.insert(
              moodEntryId: 'does-not-exist',
              emotionKey: 'joy',
              intensity: 3,
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('mood entry keeps its emotions and tag links; delete cascades', () async {
    await db.into(db.moodEntries).insert(
          MoodEntriesCompanion.insert(
            id: 'm1',
            occurredAt: DateTime(2026, 8, 20, 9),
            mood: 4,
            note: const Value('felt ok'),
          ),
        );
    await db.batch((b) {
      b.insertAll(db.moodEntryEmotions, [
        MoodEntryEmotionsCompanion.insert(
            moodEntryId: 'm1', emotionKey: 'joy', intensity: 3),
        MoodEntryEmotionsCompanion.insert(
            moodEntryId: 'm1', emotionKey: 'trust', intensity: 2),
      ]);
    });
    await db.into(db.tags).insert(TagsCompanion.insert(id: 't1', name: 'work'));
    await db.into(db.moodEntryTags).insert(
          MoodEntryTagsCompanion.insert(moodEntryId: 'm1', tagId: 't1'),
        );

    expect(await db.select(db.moodEntryEmotions).get(), hasLength(2));

    await (db.delete(db.moodEntries)..where((t) => t.id.equals('m1'))).go();

    expect(await db.select(db.moodEntryEmotions).get(), isEmpty);
    expect(await db.select(db.moodEntryTags).get(), isEmpty);
    // The tag itself is shared and must survive.
    expect(await db.select(db.tags).get(), hasLength(1));
  });

  test('journal entry stores markdown verbatim', () async {
    const md = '# Today\n\n- talked about **boundaries**\n';
    await db.into(db.journalEntries).insert(
          JournalEntriesCompanion.insert(
            id: 'j1',
            entryDate: DateTime(2026, 8, 20),
            bodyMarkdown: md,
            title: const Value('Session 3'),
          ),
        );

    final entry = await (db.select(db.journalEntries)
          ..where((t) => t.id.equals('j1')))
        .getSingle();

    expect(entry.bodyMarkdown, md);
    expect(entry.title, 'Session 3');
  });

  test('task status round-trips and closing records completion', () async {
    await db.into(db.tasks).insert(
          TasksCompanion.insert(
            id: 'k1',
            title: 'Practice box breathing',
            status: TaskStatus.pending,
          ),
        );

    var task = await (db.select(db.tasks)..where((t) => t.id.equals('k1')))
        .getSingle();
    expect(task.status, TaskStatus.pending);

    await (db.update(db.tasks)..where((t) => t.id.equals('k1'))).write(
      TasksCompanion(
        status: const Value(TaskStatus.done),
        completedAt: Value(DateTime(2026, 8, 25)),
        closingNote: const Value('went well'),
      ),
    );

    task = await (db.select(db.tasks)..where((t) => t.id.equals('k1')))
        .getSingle();
    expect(task.status, TaskStatus.done);
    expect(task.completedAt, DateTime(2026, 8, 25));
    expect(task.closingNote, 'went well');
  });

  test('tag name is unique', () async {
    await db.into(db.tags).insert(TagsCompanion.insert(id: 't1', name: 'work'));

    expect(
      () => db
          .into(db.tags)
          .insert(TagsCompanion.insert(id: 't2', name: 'work')),
      throwsA(isA<SqliteException>()),
    );
  });
}
