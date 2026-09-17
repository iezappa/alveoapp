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

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
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
        await m.addColumn(journalEntries, journalEntries.section);
        await m.addColumn(journalEntries, journalEntries.isMonthlyReview);
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
    },
    beforeOpen: (details) async {
      // Drift does not enable foreign keys by default.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
