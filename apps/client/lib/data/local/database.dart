import 'package:drift/drift.dart';

import 'connection/connection.dart';
import 'storage_durability.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    MoodEntries,
    MoodEntryEmotions,
    JournalEntries,
    JournalEntryEmotions,
    Tasks,
    Tags,
    MoodEntryTags,
    JournalEntryTags,
    AppSettings,
    Sessions,
    SessionLinks,
    ThoughtRecords,
    ThoughtRecordDistortions,
    Medications,
    MedicationLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// The running app's persistent database (file on native, WASM on web).
  ///
  /// [onStorageChosen] is told, on the web, which browser storage drift got.
  AppDatabase.connect({void Function(StorageDurability)? onStorageChosen})
    : super(
        openConnection(
          name: storeName,
          sqlite3Uri: sqlite3WasmUri,
          driftWorkerUri: driftWorkerUri,
          onStorageChosen: onStorageChosen,
        ),
      );

  /// `alveo.sqlite` on native platforms, the browser database of the same
  /// name on the web. Recovery deletes it by this name.
  static const storeName = 'alveo';

  /// Where the web build finds its database engine (files in `web/`).
  static final sqlite3WasmUri = Uri.parse('sqlite3.wasm');
  static final driftWorkerUri = Uri.parse('drift_worker.js');

  /// The schema this build writes, readable without opening a store — which
  /// is exactly when recovery needs it.
  static const currentSchemaVersion = 9;

  /// In-memory database for tests. Each instance is isolated.
  factory AppDatabase.forTesting() => AppDatabase(openInMemory());

  @override
  int get schemaVersion => currentSchemaVersion;

  Future<bool> _hasColumn(TableInfo table, String column) async {
    final existing = await customSelect(
      'PRAGMA table_info("${table.actualTableName}")',
    ).get();
    return existing.any((c) => c.read<String>('name') == column);
  }

  /// [Migrator.addColumn], skipped when the column is already there.
  ///
  /// SQLite has no `ADD COLUMN IF NOT EXISTS`: replaying an interrupted
  /// upgrade would throw `duplicate column`, drift would remember the failed
  /// migration, and the store would never open again.
  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo table,
    GeneratedColumn column,
  ) async {
    if (await _hasColumn(table, column.name)) return;
    await m.addColumn(table, column);
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // One transaction around every step, so an upgrade is all or nothing.
      //
      // drift writes `user_version` only after this callback returns, so a
      // process killed halfway leaves a store that still claims the old
      // version with part of the new shape on disk. With the transaction the
      // crash rolls it back to exactly the version it claims; SQLite makes
      // DDL transactional. The steps are idempotent anyway
      // (`_addColumnIfMissing`, `CREATE TABLE IF NOT EXISTS`, the v9 skip),
      // because a store already half-upgraded by an earlier build without
      // the transaction still has to open.
      await transaction(() async {
        if (from < 2) {
          await m.createTable(appSettings);
        }
        if (from < 3) {
          await m.createTable(sessions);
        }
        if (from < 4) {
          await m.createTable(sessionLinks);
        }
        if (from < 5) {
          await _addColumnIfMissing(m, journalEntries, journalEntries.section);
          await _addColumnIfMissing(
            m,
            journalEntries,
            journalEntries.isMonthlyReview,
          );
        }
        if (from < 6) {
          await m.createTable(journalEntryEmotions);
        }
        if (from < 7) {
          await m.createTable(thoughtRecords);
          await m.createTable(thoughtRecordDistortions);
        }
        if (from < 8) {
          await m.createTable(medications);
          await m.createTable(medicationLogs);
        }
        if (from < 9) {
          // updatedAt everywhere. Rows that were already there get their
          // createdAt where there is one — "changed when it was written" is
          // true and keeps the history — and the migration's own clock
          // otherwise, which is the earliest moment anything is known about
          // a row with no timestamp of its own.
          for (final entry in <TableInfo, GeneratedColumn<DateTime>?>{
            moodEntries: moodEntries.createdAt,
            moodEntryEmotions: null,
            journalEntryEmotions: null,
            tasks: tasks.createdAt,
            thoughtRecords: thoughtRecords.createdAt,
            thoughtRecordDistortions: null,
            medications: medications.createdAt,
            medicationLogs: medicationLogs.takenAt,
            tags: null,
            moodEntryTags: null,
            journalEntryTags: null,
            appSettings: null,
            sessions: sessions.createdAt,
            sessionLinks: null,
          }.entries) {
            final table = entry.key;
            // A replay after a crash finds some tables already rebuilt; doing
            // them again would re-stamp updatedAt for nothing.
            if (await _hasColumn(table, 'updated_at')) continue;
            final updatedAt = table.columnsByName['updated_at']!;
            await m.alterTable(
              TableMigration(
                table,
                newColumns: [updatedAt],
                columnTransformer: {
                  if (entry.value != null) updatedAt: entry.value!,
                },
              ),
            );
          }
        }
      });
    },
    beforeOpen: (details) async {
      // Drift does not enable foreign keys by default.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
