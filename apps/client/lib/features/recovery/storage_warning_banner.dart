import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/storage_durability.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../transfer/backup_actions.dart';

/// Whether the storage warning was put away for this run of the app.
///
/// Not persisted on purpose: the storage does not get any safer for having
/// been dismissed, so the next launch says it again.
class StorageWarningDismissed extends Notifier<bool> {
  @override
  bool build() => false;

  void dismiss() => state = true;
}

final storageWarningDismissedProvider =
    NotifierProvider<StorageWarningDismissed, bool>(
      StorageWarningDismissed.new,
    );

/// Says so when the browser gave the database storage that can lose it.
///
/// Non-blocking — the app is usable on IndexedDB — but never silent: an app
/// whose whole promise is "your notes live on your device" must not quietly
/// run on a device that forgets. It carries no user data, and it sits inside
/// the app shell, which the PIN lock screen replaces entirely.
class StorageWarningBanner extends ConsumerWidget {
  const StorageWarningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final durability = ref.watch(storageDurabilityProvider);
    final dismissed = ref.watch(storageWarningDismissedProvider);
    if (durability == StorageDurability.durable || dismissed) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final volatile = durability == StorageDurability.volatile;

    return MaterialBanner(
      backgroundColor: volatile
          ? scheme.errorContainer
          : scheme.tertiaryContainer,
      leading: Icon(
        volatile ? Icons.error_outline : Icons.warning_amber_outlined,
        color: volatile ? scheme.error : null,
      ),
      content: Text(
        volatile ? l10n.storageVolatileWarning : l10n.storageDegradedWarning,
      ),
      actions: [
        TextButton(
          onPressed: () =>
              ref.read(storageWarningDismissedProvider.notifier).dismiss(),
          child: Text(l10n.storageWarningDismiss),
        ),
        FilledButton.tonal(
          onPressed: () => runExportBackup(context, ref),
          child: Text(l10n.storageExportNow),
        ),
      ],
    );
  }
}
