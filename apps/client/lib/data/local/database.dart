import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    MoodEntries,
    MoodEntryEmotions,
    JournalEntries,
    Tasks,
    Tags,
    MoodEntryTags,
    JournalEntryTags,
    AppSettings,
    Sessions,
    SessionLinks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// File-backed database for the running app.
  AppDatabase.file(File file) : super(NativeDatabase.createInBackground(file));

  /// In-memory database for tests. Each instance is isolated.
  factory AppDatabase.forTesting() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 4;

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
    },
    beforeOpen: (details) async {
      // Drift does not enable foreign keys by default.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Default on-device database file: `<app documents>/terapia.sqlite`.
Future<File> defaultDatabaseFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'terapia.sqlite'));
}
