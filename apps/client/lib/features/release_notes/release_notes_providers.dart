import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/release_notes/app_version.dart';
import '../../domain/release_notes/release_notes.dart';
import '../../l10n/app_localizations.dart';

/// Settings key holding the newest version whose notes were handled.
const lastSeenVersionSettingKey = 'release_notes.last_seen_version';

/// The changelog in [languageCode] (English when not shipped).
final releaseNotesProvider = FutureProvider.family<ReleaseNotes, String>((
  ref,
  languageCode,
) async {
  final lang = languageCode == 'es' ? 'es' : 'en';
  return ReleaseNotes.parse(
    await rootBundle.loadString('assets/release_notes/$lang.json'),
  );
});

/// On launch: shows "What's new" when this build is newer than the last one
/// seen, then records this version. A first install shows nothing and just
/// records it. Never throws — a changelog problem must not stop a launch.
Future<void> announceReleaseNotes(BuildContext context, WidgetRef ref) async {
  final language = Localizations.localeOf(context).languageCode;
  final settings = ref.read(settingsRepositoryProvider);
  try {
    final notes = await ref.read(releaseNotesProvider(language).future);
    final lastSeen = AppVersion.tryParse(
      await settings.get(lastSeenVersionSettingKey),
    );
    final unseen = notes.toAnnounce(lastSeen);
    if (unseen.isNotEmpty && context.mounted) {
      await showReleaseNotesDialog(context, notes.current, unseen);
    }
    await settings.set(lastSeenVersionSettingKey, '${notes.current}');
  } on Object {
    // Nothing to announce.
  }
}

Future<void> showReleaseNotesDialog(
  BuildContext context,
  AppVersion current,
  List<ReleaseNote> releases,
) => showDialog<void>(
  context: context,
  builder: (context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(l10n.whatsNewTitle('$current')),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final release in releases) ...[
                if (releases.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      '${release.version}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                for (final line in release.highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('•  $line'),
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.whatsNewClose),
        ),
      ],
    );
  },
);
