import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/onboarding_controller.dart';
import '../../l10n/app_localizations.dart';

/// The backup notice: the data lives only on this device.
///
/// Shown at the end of onboarding, and once to anyone onboarded before it
/// existed. It only closes by accepting it: the point is that nobody keeps
/// using the app without having been told no other copy exists.
Future<void> showBackupNoticeDialog(BuildContext context) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => const _BackupNoticeDialog(),
);

class _BackupNoticeDialog extends ConsumerWidget {
  const _BackupNoticeDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: AlertDialog(
        icon: const Icon(Icons.phone_android_outlined),
        title: Text(l10n.backupNoticeTitle),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Text(l10n.backupNoticeOnboarding),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              await ref.read(backupNoticeAcceptedProvider.notifier).accept();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(l10n.backupNoticeAccept),
          ),
        ],
      ),
    );
  }
}
