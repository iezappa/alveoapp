// Migration tests run against the schema snapshots in `drift_schemas/`.
//
// v1–v7 were dumped from the code as it stood at the last commit of each
// version (c045d27, f491230, 32a7ea0, 7971245, dea2f06, 274a1f4, 773e197);
// v8 from the code that ships it. Adding a version means bumping
// `currentSchemaVersion`, writing the step in `AppDatabase.migration`, then:
//
//   dart run drift_dev schema dump lib/data/local/database.dart drift_schemas/
//   dart run drift_dev schema generate --data-classes --companions \
//     drift_schemas/ test/generated_migrations/
// drift exports an `isNull` expression builder that collides with the matcher.
import 'package:alveo/data/local/database.dart';
import 'package:alveo/domain/journal/journal_section.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../generated_migrations/schema.dart';
import '../../generated_migrations/schema_v1.dart' as v1;
import '../../generated_migrations/schema_v4.dart' as v4;
import '../../generated_migrations/schema_v8.dart' as v8;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('the snapshots cover every version up to the current one', () {
    expect(GeneratedHelper.versions, [
      for (var v = 1; v <= AppDatabase.currentSchemaVersion; v++) v,
    ]);
  });

  // An installed copy can be any age and upgrades through every remaining
  // step at once. `AppDatabase` always migrates to its own version, so each
  // test starts from one snapshot and ends at the current one: a failure
  // names the version it started from.
  for (final from in GeneratedHelper.versions) {
    if (from == AppDatabase.currentSchemaVersion) continue;
    test('upgrades v$from straight to the current schema', () async {
      final schema = await verifier.schemaAt(from);
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
    });
  }

  test(
    'what a v1 user wrote survives the upgrade to the current schema',
    () async {
      final schema = await verifier.schemaAt(1);
      final before = v1.DatabaseAtV1(schema.newConnection());
      final at = DateTime(2026, 3, 11, 9).millisecondsSinceEpoch ~/ 1000;
      await before
          .into(before.moodEntries)
          .insert(
            v1.MoodEntriesCompanion.insert(
              id: 'm1',
              occurredAt: at,
              mood: 4,
              note: const Value('slept well'),
            ),
          );
      await before
          .into(before.journalEntries)
          .insert(
            v1.JournalEntriesCompanion.insert(
              id: 'j1',
              entryDate: at,
              bodyMarkdown: 'first entry',
            ),
          );
      await before
          .into(before.tasks)
          .insert(
            v1.TasksCompanion.insert(id: 't1', title: 'Breathe', status: 0),
          );
      await before.close();

      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

      final mood = await db.select(db.moodEntries).getSingle();
      expect(mood.id, 'm1');
      expect(mood.mood, 4);
      expect(mood.note, 'slept well');
      final journal = await db.select(db.journalEntries).getSingle();
      expect(journal.bodyMarkdown, 'first entry');
      expect((await db.select(db.tasks).getSingle()).title, 'Breathe');
    },
  );

  test('journal entries from v4 land in the one-liner notebook', () async {
    final schema = await verifier.schemaAt(4);
    final before = v4.DatabaseAtV4(schema.newConnection());
    await before
        .into(before.journalEntries)
        .insert(
          v4.JournalEntriesCompanion.insert(
            id: 'j1',
            entryDate: 0,
            bodyMarkdown: 'before notebooks',
          ),
        );
    await before.close();

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    final entry = await db.select(db.journalEntries).getSingle();
    expect(entry.bodyMarkdown, 'before notebooks');
    expect(entry.section, JournalSection.oneLiner);
    expect(entry.isMonthlyReview, isFalse);
  });

  test('v9 stamps updatedAt from what the row already knew', () async {
    final schema = await verifier.schemaAt(8);
    final created = DateTime(2026, 5, 4, 12, 30);
    final before = v8.DatabaseAtV8(schema.newConnection());
    await before
        .into(before.moodEntries)
        .insert(
          v8.MoodEntriesCompanion.insert(
            id: 'm1',
            occurredAt: DateTime(2026, 5, 4, 12).millisecondsSinceEpoch ~/ 1000,
            mood: 3,
            createdAt: Value(created.millisecondsSinceEpoch ~/ 1000),
          ),
        );
    await before
        .into(before.tags)
        .insert(v8.TagsCompanion.insert(id: 't1', name: 'work'));
    await before.close();

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 9);

    // A row with a createdAt keeps its own history.
    expect((await db.select(db.moodEntries).getSingle()).updatedAt, created);
    // One without gets a real timestamp rather than null.
    expect((await db.select(db.tags).getSingle()).updatedAt, isNotNull);
  });
}
