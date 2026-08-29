import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

/// Donation links for keeping the developer's projects going. Both are shown
/// side by side — the reader picks the one that fits their country instead of
/// the app trying to guess it (this app has no networking and no geo-IP).
const cafecitoUrl = 'https://cafecito.app/iezappa';
const patreonUrl = 'https://www.patreon.com/cw/iezappa';

/// Opens [url] in the platform browser. Extracted so widgets can inject a fake
/// in tests without touching the url_launcher platform channel.
typedef UrlOpener = Future<bool> Function(Uri url);

Future<bool> launchExternalUrl(Uri url) =>
    launchUrl(url, mode: LaunchMode.externalApplication);

/// A short "support my projects" block with a donation button per platform.
/// Reused in Settings and on the first tutorial slide.
class SupportProjectsCard extends StatelessWidget {
  const SupportProjectsCard({super.key, this.open = launchExternalUrl});

  final UrlOpener open;

  Future<void> _launch(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    var ok = false;
    try {
      ok = await open(Uri.parse(url));
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      messenger?.showSnackBar(SnackBar(content: Text(l10n.supportLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.supportTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          l10n.supportBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              key: const ValueKey('support-cafecito'),
              onPressed: () => _launch(context, cafecitoUrl),
              icon: const Icon(Icons.local_cafe_outlined),
              label: Text(l10n.supportCafecito),
            ),
            FilledButton.tonalIcon(
              key: const ValueKey('support-patreon'),
              onPressed: () => _launch(context, patreonUrl),
              icon: const Icon(Icons.favorite_outline),
              label: Text(l10n.supportPatreon),
            ),
          ],
        ),
      ],
    );
  }
}
