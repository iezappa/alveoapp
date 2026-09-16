import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_restart.dart';
import '../../data/local/database.dart';
import '../../data/local/local_store.dart' as local_store;
import '../../data/providers.dart';
import '../../data/transfer/backup_service.dart';
import '../../domain/transfer/import_report.dart';

/// Deletes the database storage itself. Overridden in tests.
final eraseLocalStoreProvider = Provider<Future<void> Function()>(
  (ref) => local_store.eraseLocalStore,
);

/// Opens a new connection to the app's store. Overridden in tests.
final openDatabaseProvider = Provider<AppDatabase Function()>(
  (ref) => AppDatabase.connect,
);

/// Lets the user pick a backup file and returns its text, or null if they
/// backed out. Overridden in tests.
final pickBackupSourceProvider = Provider<Future<String?> Function()>(
  (ref) => () async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'JSON', extensions: ['json']),
      ],
    );
    return file?.readAsString();
  },
);

/// The way out of a store that cannot be opened.
///
/// Neither option tries to repair the store in place: a database that fails
/// to open has already shown it cannot be trusted, and a repair that guesses
/// wrong looks exactly like one that worked. Both start from empty, both are
/// asked for explicitly by the user, and both end by starting the app again.
class DatabaseRecoveryActions {
  DatabaseRecoveryActions(this._ref);

  final Ref _ref;

  /// Deletes the store and starts the app over, empty.
  Future<void> reset() async {
    await _eraseStore();
    await _ref.read(restartAppProvider)();
  }

  /// Puts a backup file where the broken store was.
  ///
  /// Returns null if the user backed out. Throws [ImportException] — before
  /// anything is deleted — if the file is not a backup this build can read.
  Future<ImportReport?> importBackup() async {
    final source = await _ref.read(pickBackupSourceProvider)();
    if (source == null) return null;

    BackupService.checkBackup(source);

    await _eraseStore();
    // The failed connection stays failed, so the restore needs a new one.
    final fresh = _ref.read(openDatabaseProvider)();
    final ImportReport report;
    try {
      report = await BackupService(fresh).importFromJson(source);
    } finally {
      await fresh.close();
    }
    await _ref.read(restartAppProvider)();
    return report;
  }

  Future<void> _eraseStore() async {
    try {
      await _ref.read(appDatabaseProvider).close();
    } on Object {
      // Closing a connection that never opened can fail too. The storage is
      // about to be deleted either way.
    }
    await _ref.read(eraseLocalStoreProvider)();
  }
}

final databaseRecoveryActionsProvider = Provider<DatabaseRecoveryActions>(
  DatabaseRecoveryActions.new,
);
