import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../app/clock.dart';
import '../../app/platform.dart';
import '../../data/providers.dart';
import '../../data/update/github_update_service.dart';
import '../../data/update/service_worker_bridge.dart';
import '../../data/update/update_throttle.dart';
import '../../data/update/web_update_service.dart';
import '../../domain/release_notes/app_version.dart';
import '../../domain/update/update_info.dart';
import '../release_notes/release_notes_providers.dart';

/// Where releases are published.
const updateRepository = 'iezappa/alveoapp';

/// Settings key holding the version whose banner was dismissed.
const dismissedUpdateSettingKey = 'update.dismissed_version';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// The version this build is: the newest entry of the bundled changelog,
/// which is also what the release notes dialog announces.
final installedVersionProvider = FutureProvider<AppVersion>(
  (ref) async => (await ref.watch(releaseNotesProvider('en').future)).current,
);

final updateServiceProvider = FutureProvider<UpdateService>((ref) async {
  final installed = await ref.watch(installedVersionProvider.future);
  final client = ref.watch(httpClientProvider);

  return ref.watch(isWebProvider)
      ? WebUpdateService(
          installed: installed,
          client: client,
          baseUri: Uri.base,
          hasWaitingWorker: hasWaitingServiceWorker,
        )
      : GitHubUpdateService(
          installed: installed,
          repository: updateRepository,
          client: client,
        );
});

/// The update to offer, or null. Throttled to one check every six hours and
/// silent about a version the user already waved away.
final updateCheckProvider = FutureProvider<UpdateInfo?>((ref) async {
  final settings = ref.watch(settingsRepositoryProvider);
  final now = ref.watch(clockProvider)();
  final last = DateTime.tryParse(
    await settings.get(lastUpdateCheckSettingKey) ?? '',
  );
  if (!shouldCheckForUpdate(lastCheck: last, now: now)) return null;

  final service = await ref.watch(updateServiceProvider.future);
  final info = await service.check();
  await settings.set(lastUpdateCheckSettingKey, now.toIso8601String());
  if (info == null) return null;

  final dismissed = AppVersion.tryParse(
    await settings.get(dismissedUpdateSettingKey),
  );
  if (dismissed != null && !(info.latest > dismissed)) return null;
  return info;
});
