import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'export/export_service.dart';
import 'local/database.dart';
import 'obsidian/obsidian_service.dart';
import 'repositories/journal_repository.dart';
import 'repositories/link_repository.dart';
import 'repositories/mood_repository.dart';
import 'repositories/session_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/task_repository.dart';
import 'search/search_service.dart';
import 'security/pin_service.dart';
import 'transfer/backup_service.dart';

/// Holds the opened [AppDatabase].
///
/// `main()` opens the database (which needs `getApplicationDocumentsDirectory`)
/// and injects it via `ProviderScope(overrides: [...])`, so this default is
/// never actually reached at runtime.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden with an opened AppDatabase',
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

final pinServiceProvider = Provider<PinService>(
  (ref) => PinService(ref.watch(settingsRepositoryProvider)),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(appDatabaseProvider)),
);

final searchServiceProvider = Provider<SearchService>(
  (ref) => SearchService(ref.watch(appDatabaseProvider)),
);

const obsidianVaultKey = 'obsidian.vault_path';

final obsidianServiceProvider = Provider<ObsidianService>(
  (ref) => ObsidianService(ref.watch(journalRepositoryProvider)),
);

final obsidianVaultProvider = FutureProvider<String?>(
  (ref) => ref.watch(settingsRepositoryProvider).get(obsidianVaultKey),
);

final moodRepositoryProvider = Provider<MoodRepository>(
  (ref) => MoodRepository(ref.watch(appDatabaseProvider)),
);

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => JournalRepository(ref.watch(appDatabaseProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(ref.watch(appDatabaseProvider)),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(ref.watch(appDatabaseProvider)),
);

final linkRepositoryProvider = Provider<LinkRepository>(
  (ref) => LinkRepository(ref.watch(appDatabaseProvider)),
);

final exportServiceProvider = Provider<ExportService>(
  (ref) => ExportService(ref.watch(appDatabaseProvider)),
);
