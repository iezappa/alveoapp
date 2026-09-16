import 'package:drift/drift.dart';

import '../../app/locale_controller.dart';
import '../../app/theme_controller.dart';
import '../local/database.dart';

/// "Delete all my data", and the question the backup reminder asks first.
class DataEraser {
  DataEraser(this._db);

  final AppDatabase _db;

  /// Settings that survive erasing everything: how the app looks and which
  /// language it speaks. None of it says anything about the person, and
  /// losing it would greet them — right after they deleted everything — in a
  /// language they may not read.
  static const keptSettingKeys = {
    localeSettingKey,
    ThemeController.modeKey,
    ThemeController.accentKey,
  };

  /// Every table that holds what the user wrote, children before parents so
  /// deleting in this order never trips a foreign key.
  List<TableInfo> get _userTables => [
    _db.moodEntryEmotions,
    _db.moodEntryTags,
    _db.journalEntryEmotions,
    _db.journalEntryTags,
    _db.sessionLinks,
    _db.thoughtRecordDistortions,
    _db.medicationLogs,
    _db.moodEntries,
    _db.journalEntries,
    _db.tasks,
    _db.tags,
    _db.sessions,
    _db.thoughtRecords,
    _db.medications,
  ];

  /// Whether the user has written anything down at all. Preferences alone do
  /// not count.
  Future<bool> holdsUserData() async {
    for (final table in _userTables) {
      final row = await _db
          .customSelect(
            'SELECT EXISTS(SELECT 1 FROM ${table.actualTableName}) AS present',
          )
          .getSingle();
      if (row.read<int>('present') == 1) return true;
    }
    return false;
  }

  /// Deletes every record and every setting except [keptSettingKeys] — the
  /// PIN, the profile, the safety plan and the onboarding flags included —
  /// in one transaction: all of it, or none of it.
  Future<void> eraseEverything() => _db.transaction(() async {
    for (final table in _userTables) {
      await _db.customStatement('DELETE FROM ${table.actualTableName}');
    }
    await (_db.delete(
      _db.appSettings,
    )..where((t) => t.key.isNotIn(keptSettingKeys))).go();
  });
}
