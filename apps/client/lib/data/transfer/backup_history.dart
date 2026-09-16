import '../local/database.dart';
import '../repositories/settings_repository.dart';

/// When the user last exported, and last put the reminder off.
///
/// Kept in app settings, which backups do not carry: a restore must not bring
/// back the date of an export that happened on another device.
class BackupHistory {
  BackupHistory(AppDatabase db) : _settings = SettingsRepository(db);

  final SettingsRepository _settings;

  static const lastExportKey = 'backup.last_export_at';
  static const reminderDismissedKey = 'backup.reminder_dismissed_at';

  Future<DateTime?> lastExportAt() => _read(lastExportKey);

  Future<DateTime?> reminderDismissedAt() => _read(reminderDismissedKey);

  Future<void> recordExport(DateTime at) =>
      _settings.set(lastExportKey, at.toIso8601String());

  Future<void> snoozeReminder(DateTime at) =>
      _settings.set(reminderDismissedKey, at.toIso8601String());

  Future<DateTime?> _read(String key) async {
    final stored = await _settings.get(key);
    return stored == null ? null : DateTime.tryParse(stored);
  }
}
