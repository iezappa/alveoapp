import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../shared/support_actions.dart' show UrlOpener;

Future<bool> _dial(Uri url) => launchUrl(url);

/// One number to call, and how to label it.
class CrisisLine {
  const CrisisLine({required this.dial, required this.label});

  final Uri dial;
  final String Function(AppLocalizations l10n) label;
}

// TODO(release): re-verify every number below at
// https://www.asistenciaalsuicida.org.ar before each release, and note the
// date checked in the release PR. Do NOT add 0800 345 1435: it could not be
// verified, and a wrong crisis number is worse than none.
/// Argentina's crisis lines (Centro de Asistencia al Suicida) and emergencies.
final crisisLines = <CrisisLine>[
  CrisisLine(dial: Uri.parse('tel:135'), label: (l10n) => l10n.crisisLine135),
  CrisisLine(
    dial: Uri.parse('tel:+541152751135'),
    label: (l10n) => l10n.crisisLineNational,
  ),
  CrisisLine(dial: Uri.parse('tel:911'), label: (l10n) => l10n.crisisEmergency),
];

/// "If you are in crisis": who to call, one tap away.
///
/// Shown in Settings → About, at the top of the safety plan and inside the
/// onboarding disclaimer. The labels stay selectable, so the number can be
/// copied on a device that cannot place calls.
class CrisisResourcesCard extends StatelessWidget {
  const CrisisResourcesCard({super.key, this.open = _dial});

  final UrlOpener open;

  Future<void> _call(BuildContext context, Uri dial) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    var ok = false;
    try {
      ok = await open(dial);
    } on Object {
      ok = false;
    }
    if (!ok) {
      messenger?.showSnackBar(SnackBar(content: Text(l10n.crisisCallError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.crisisTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.crisisIntro,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
            ),
            for (final line in crisisLines)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.phone_outlined),
                title: Text(line.label(l10n)),
                onTap: () => _call(context, line.dial),
              ),
          ],
        ),
      ),
    );
  }
}
