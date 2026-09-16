import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/onboarding_controller.dart';
import '../../l10n/app_localizations.dart';
import 'crisis_resources.dart';

/// The care disclaimer, accepted once before the app is used.
///
/// Only closes by accepting it. Carries the crisis lines too, so the first
/// thing the app says about emergencies comes with who to call.
Future<void> showDisclaimerDialog(BuildContext context) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => const _DisclaimerDialog(),
);

class _DisclaimerDialog extends ConsumerWidget {
  const _DisclaimerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: AlertDialog(
        icon: const Icon(Icons.health_and_safety_outlined),
        title: Text(l10n.disclaimerAcceptTitle),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.disclaimerAcceptBody),
                const SizedBox(height: 16),
                const CrisisResourcesCard(),
              ],
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              await ref.read(disclaimerAcceptedProvider.notifier).accept();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(l10n.disclaimerAcceptAction),
          ),
        ],
      ),
    );
  }
}
