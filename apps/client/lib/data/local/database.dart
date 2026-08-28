import 'package:drift/drift.dart';

import 'connection/connection.dart';
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
  AppDatabase.connect() : super(openConnection());

  /// In-memory database for tests. Each instance is isolated.
  factory AppDatabase.forTesting() => AppDatabase(openInMemory());

  @override
  int get schemaVersion => 8;

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
    },
    beforeOpen: (details) async {
      // Drift does not enable foreign keys by default.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
