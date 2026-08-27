import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/database.dart';
import 'repositories/journal_repository.dart';
import 'repositories/mood_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/timeline_repository.dart';

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

final moodRepositoryProvider = Provider<MoodRepository>(
  (ref) => MoodRepository(ref.watch(appDatabaseProvider)),
);

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => JournalRepository(ref.watch(appDatabaseProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(ref.watch(appDatabaseProvider)),
);

final timelineRepositoryProvider = Provider<TimelineRepository>(
  (ref) => TimelineRepository(
    ref.watch(moodRepositoryProvider),
    ref.watch(journalRepositoryProvider),
    ref.watch(taskRepositoryProvider),
  ),
);
