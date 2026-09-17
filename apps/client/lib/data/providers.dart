import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'export/export_service.dart';
import 'local/database.dart';
import 'local/database_health.dart';
import 'local/storage_durability.dart';
import 'obsidian/obsidian_service.dart';
import '../domain/repositories/repositories.dart';
import 'repositories/journal_repository.dart';
import 'repositories/link_repository.dart';
import 'repositories/medication_repository.dart';
import 'repositories/mood_repository.dart';
import 'repositories/session_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/safety_plan_repository.dart';
import 'repositories/tag_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/thought_record_repository.dart';
import 'search/search_service.dart';
import 'security/pin_service.dart';
import 'transfer/backup_history.dart';
import 'transfer/backup_service.dart';
import 'transfer/csv_export.dart';
import 'transfer/data_eraser.dart';

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
  (ref) => DriftSettingsRepository(ref.watch(appDatabaseProvider)),
);

final pinServiceProvider = Provider<PinService>(
  (ref) => PinService(ref.watch(settingsRepositoryProvider)),
);

final safetyPlanRepositoryProvider = Provider<SafetyPlanRepository>(
  (ref) => DriftSafetyPlanRepository(ref.watch(settingsRepositoryProvider)),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(appDatabaseProvider)),
);

final csvExportServiceProvider = Provider<CsvExportService>(
  (ref) => CsvExportService(ref.watch(appDatabaseProvider)),
);

final backupHistoryProvider = Provider<BackupHistory>(
  (ref) => BackupHistory(ref.watch(appDatabaseProvider)),
);

final dataEraserProvider = Provider<DataEraser>(
  (ref) => DataEraser(ref.watch(appDatabaseProvider)),
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
  (ref) => DriftMoodRepository(ref.watch(appDatabaseProvider)),
);

/// All mood check-ins, newest first. Invalidate after a new check-in.
final moodEntriesProvider = FutureProvider(
  (ref) => ref.watch(moodRepositoryProvider).getAll(),
);

final tagRepositoryProvider = Provider<TagRepository>(
  (ref) => DriftTagRepository(ref.watch(appDatabaseProvider)),
);

/// Every tag, alphabetical.
final allTagsProvider = FutureProvider(
  (ref) => ref.watch(tagRepositoryProvider).all(),
);

/// All mood-entry ↔ tag links; refreshes with [moodEntriesProvider].
final moodTagLinksProvider = FutureProvider((ref) {
  ref.watch(moodEntriesProvider);
  return ref.read(tagRepositoryProvider).moodTagLinks();
});

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => DriftJournalRepository(ref.watch(appDatabaseProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => DriftTaskRepository(ref.watch(appDatabaseProvider)),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => DriftSessionRepository(ref.watch(appDatabaseProvider)),
);

final linkRepositoryProvider = Provider<LinkRepository>(
  (ref) => DriftLinkRepository(ref.watch(appDatabaseProvider)),
);

final thoughtRecordRepositoryProvider = Provider<ThoughtRecordRepository>(
  (ref) => DriftThoughtRecordRepository(ref.watch(appDatabaseProvider)),
);

final medicationRepositoryProvider = Provider<MedicationRepository>(
  (ref) => DriftMedicationRepository(ref.watch(appDatabaseProvider)),
);

final exportServiceProvider = Provider<ExportService>(
  (ref) => ExportService(ref.watch(appDatabaseProvider)),
);

/// What the storage underneath the database can be trusted with.
///
/// Durable until told otherwise: native platforms never report, and a web
/// build that has not opened yet has nothing to warn about.
class StorageDurabilityController extends Notifier<StorageDurability> {
  @override
  StorageDurability build() => StorageDurability.durable;

  void report(StorageDurability durability) => state = durability;
}

final storageDurabilityProvider =
    NotifierProvider<StorageDurabilityController, StorageDurability>(
      StorageDurabilityController.new,
    );

/// Whether the database opened, checked once per app start.
final databaseHealthProvider = FutureProvider<DatabaseHealth>(
  (ref) => probeDatabase(ref.watch(appDatabaseProvider)),
);
