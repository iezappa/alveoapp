import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';

/// Whether the export warning was muted for this run of the app.
///
/// Never persisted: muting it for good would mean nobody is reminded again
/// that the file leaves the app's protection.
class SensitiveExportWarningMuted extends Notifier<bool> {
  @override
  bool build() => false;

  void mute() => state = true;
}

final sensitiveExportWarningMutedProvider =
    NotifierProvider<SensitiveExportWarningMuted, bool>(
      SensitiveExportWarningMuted.new,
    );

/// Warns that an exported file holds therapy notes in the clear.
///
/// Returns whether to go on writing it. Called before every export that
/// writes a file the app no longer protects: the JSON backup, the Obsidian
/// export, a session PDF and the daily Markdown.
Future<bool> confirmSensitiveExport(BuildContext context, WidgetRef ref) async {
  if (ref.read(sensitiveExportWarningMutedProvider)) return true;

  final result = await showDialog<_Answer>(
    context: context,
    builder: (_) => const _SensitiveExportDialog(),
  );
  if (result == null || !result.proceed) return false;
  if (result.muteForSession) {
    ref.read(sensitiveExportWarningMutedProvider.notifier).mute();
  }
  return true;
}

typedef _Answer = ({bool proceed, bool muteForSession});

class _SensitiveExportDialog extends StatefulWidget {
  const _SensitiveExportDialog();

  @override
  State<_SensitiveExportDialog> createState() => _SensitiveExportDialogState();
}

class _SensitiveExportDialogState extends State<_SensitiveExportDialog> {
  bool _mute = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      icon: const Icon(Icons.lock_open_outlined),
      title: Text(l10n.sensitiveExportTitle),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sensitiveExportBody),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _mute,
              onChanged: (value) => setState(() => _mute = value ?? false),
              title: Text(l10n.sensitiveExportMute),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context)
                  .pop((proceed: false, muteForSession: false)),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop((proceed: true, muteForSession: _mute)),
          child: Text(l10n.sensitiveExportContinue),
        ),
      ],
    );
  }
}
