// A migration that is interrupted has to be survivable.
//
// drift writes `user_version` only after the whole `onUpgrade` callback
// returns, so a process killed halfway through leaves a store whose recorded
// version is the one it started at and whose tables are already partly in the
// new shape. The next launch replays the upgrade from the beginning. Every
// step it re-runs has to be a no-op on the work it already did, or the store
// never opens again — and for a therapy journal kept on one device, that is
// every entry the user ever wrote.
//
// These tests build exactly that state by hand: a dump at an old version with
// part of a later step already applied, `user_version` untouched.
import 'package:alveo/data/local/database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../generated_migrations/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;
  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  /// Runs [statements] against [schema] raw, at [version], without letting
  /// drift record any migration.
  Future<void> raw(
    InitializedSchema schema,
    int version,
    List<String> statements,
  ) async {
    final db = _RawDatabase(schema.newConnection(), version);
    for (final statement in statements) {
      await db.customStatement(statement);
    }
    await db.close();
  }

  test('finishes an upgrade killed between the two v5 columns', () async {
    final schema = await verifier.schemaAt(4);
    await raw(schema, 4, [
      "INSERT INTO journal_entries (id, entry_date, body_markdown) "
          "VALUES ('j1', 0, 'still here')",
      // The first of v5's two ADD COLUMNs ran; the second never did.
      'ALTER TABLE journal_entries ADD COLUMN section INTEGER NOT NULL '
          'DEFAULT 0',
    ]);

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    final entry = await db.select(db.journalEntries).getSingle();
    expect(entry.bodyMarkdown, 'still here');
    expect(entry.isMonthlyReview, isFalse);
  });

  test('finishes an upgrade killed after both v5 columns', () async {
    final schema = await verifier.schemaAt(4);
    await raw(schema, 4, [
      "INSERT INTO journal_entries (id, entry_date, body_markdown) "
          "VALUES ('j1', 0, 'still here')",
      'ALTER TABLE journal_entries ADD COLUMN section INTEGER NOT NULL '
          'DEFAULT 0',
      'ALTER TABLE journal_entries ADD COLUMN is_monthly_review INTEGER '
          'NOT NULL DEFAULT 0 CHECK ("is_monthly_review" IN (0, 1))',
    ]);

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    expect(
      (await db.select(db.journalEntries).getSingle()).bodyMarkdown,
      'still here',
    );
  });

  test('finishes an upgrade killed after a v6 table was created', () async {
    final schema = await verifier.schemaAt(5);
    final v6 = await verifier.schemaAt(6);
    // Take v6's CREATE TABLE for journal_entry_emotions verbatim.
    final probe = _RawDatabase(v6.newConnection(), 6);
    final create =
        (await probe
                .customSelect(
                  "SELECT sql FROM sqlite_master WHERE name = 'journal_entry_emotions'",
                )
                .getSingle())
            .read<String>('sql');
    await probe.close();

    await raw(schema, 5, [
      "INSERT INTO journal_entries (id, entry_date, body_markdown) "
          "VALUES ('j1', 0, 'still here')",
      create,
    ]);

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    expect(
      (await db.select(db.journalEntries).getSingle()).bodyMarkdown,
      'still here',
    );
  });

  test('finishes an upgrade killed partway through the v9 rebuilds', () async {
    final schema = await verifier.schemaAt(8);
    final created = DateTime(2026, 5, 4, 12).millisecondsSinceEpoch ~/ 1000;
    final rebuilt = (await _createSql(
      verifier,
      9,
      'mood_entries',
    )).replaceFirst('"mood_entries"', '"tmp_for_copy_mood_entries"');
    await raw(schema, 8, [
      "INSERT INTO mood_entries (id, occurred_at, mood, created_at) "
          "VALUES ('m1', $created, 3, $created)",
      "INSERT INTO tags (id, name) VALUES ('t1', 'work')",
      // drift's alterTable rebuilt mood_entries — its own transaction
      // committed — and the process died before the next table.
      rebuilt,
      'INSERT INTO tmp_for_copy_mood_entries '
          'SELECT *, created_at FROM mood_entries',
      'DROP TABLE mood_entries',
      'ALTER TABLE tmp_for_copy_mood_entries RENAME TO mood_entries',
    ]);

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    final mood = await db.select(db.moodEntries).getSingle();
    expect(mood.mood, 3);
    expect(mood.updatedAt, mood.createdAt);
    expect((await db.select(db.tags).getSingle()).name, 'work');
  });

  test('a failing step rolls the whole upgrade back', () async {
    final schema = await verifier.schemaAt(4);
    // A foreign `thought_records` survives v7's CREATE TABLE IF NOT EXISTS
    // and breaks v9's rebuild of it, so the upgrade fails well after v5 ran.
    await raw(schema, 4, ['CREATE TABLE thought_records (x INTEGER)']);

    final db = AppDatabase(schema.newConnection());
    await expectLater(db.customSelect('SELECT 1').get(), throwsA(anything));
    await db.close();

    final after = _RawDatabase(schema.newConnection(), 4);
    addTearDown(after.close);
    final columns = await after
        .customSelect('PRAGMA table_info("journal_entries")')
        .get();
    expect(
      columns.map((c) => c.read<String>('name')),
      isNot(contains('section')),
      reason: 'v5 must roll back with the failed step',
    );
  });
}

/// The `CREATE TABLE` statement [table] had in the snapshot at [version].
Future<String> _createSql(
  SchemaVerifier verifier,
  int version,
  String table,
) async {
  final schema = await verifier.schemaAt(version);
  final db = _RawDatabase(schema.newConnection(), version);
  try {
    return (await db
            .customSelect(
              'SELECT sql FROM sqlite_master WHERE name = ?',
              variables: [Variable<String>(table)],
            )
            .getSingle())
        .read<String>('sql');
  } finally {
    await db.close();
  }
}

class _RawDatabase extends GeneratedDatabase {
  _RawDatabase(super.executor, this.schemaVersion);

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  final int schemaVersion;
}
