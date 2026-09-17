import 'package:drift/drift.dart';

import '../local/database.dart';
import '../../domain/repositories/settings_repository.dart';

/// Thin accessor over the [AppSettings] key/value table.
class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<String?> get(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> set(String key, String value) {
    return _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> remove(String key) {
    return (_db.delete(_db.appSettings)..where((t) => t.key.equals(key))).go();
  }
}
