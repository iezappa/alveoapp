import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/platform.dart';
import '../../data/providers.dart';
import '../../data/update/service_worker_bridge.dart';
import '../../domain/update/update_info.dart';
import '../../l10n/app_localizations.dart';
import '../shared/support_actions.dart';
import '../transfer/backup_actions.dart';
import 'update_providers.dart';

/// "A new version is available", docked under the open tab with the other
/// notices. Never blocking, and never shown over the lock screen: it lives
/// inside the app shell, which a locked app does not build.
class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key, this.open = launchExternalUrl});

  final UrlOpener open;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = ref.watch(updateCheckProvider).asData?.value;
    if (info == null) return const SizedBox.shrink();

    final tooOld =
        info.minSupportedVersion != null &&
        ref.watch(installedVersionProvider).asData?.value != null &&
        ref.watch(installedVersionProvider).asData!.value <
            info.minSupportedVersion!;

    return MaterialBanner(
      leading: const Icon(Icons.system_update_outlined),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.updateAvailableTitle),
          Text(l10n.updateAvailableBody('${info.latest}')),
          // A release that changes how data is stored asks for a backup
          // first: the migration runs on the only copy that exists.
          if (info.schemaChange)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(l10n.updateAvailableBackupHint),
            ),
          if (tooOld)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(l10n.updateUnsupportedPath),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ref
                .read(settingsRepositoryProvider)
                .set(dismissedUpdateSettingKey, '${info.latest}');
            ref.invalidate(updateCheckProvider);
          },
          child: Text(l10n.updateActionDismiss),
        ),
        if (info.schemaChange)
          TextButton(
            onPressed: () => runExportBackup(context, ref),
            child: Text(l10n.updateActionExport),
          ),
        FilledButton.tonal(
          onPressed: () => _apply(ref, info),
          child: Text(
            ref.watch(isWebProvider)
                ? l10n.updateActionReload
                : l10n.updateActionDownload,
          ),
        ),
      ],
    );
  }

  Future<void> _apply(WidgetRef ref, UpdateInfo info) async {
    if (ref.read(isWebProvider)) {
      await applyServiceWorkerUpdate();
      return;
    }
    await open(info.androidUrl ?? info.url);
  }
}
