import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Warns that an exported file holds therapy notes in the clear.
///
/// Returns whether to go on writing it. Called before every export that
/// writes a file the app no longer protects: the JSON backup, the Obsidian
/// export, a session PDF and the daily Markdown.
///
/// There is no way to silence this. It used to be mutable for the run of the
/// app, which meant every later export of any kind wrote therapy notes in the
/// clear without saying so. One dialog before a deliberate action is cheap.
Future<bool> confirmSensitiveExport(BuildContext context) async {
  final proceed = await showDialog<bool>(
    context: context,
    builder: (_) => const _SensitiveExportDialog(),
  );
  return proceed ?? false;
}

class _SensitiveExportDialog extends StatelessWidget {
  const _SensitiveExportDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      icon: const Icon(Icons.lock_open_outlined),
      title: Text(l10n.sensitiveExportTitle),
      content: SizedBox(width: 420, child: Text(l10n.sensitiveExportBody)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.sensitiveExportContinue),
        ),
      ],
    );
  }
}
