import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_restart.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import 'backup_actions.dart';

/// "Delete all my data", the last row of the data section.
class EraseAllDataTile extends StatelessWidget {
  const EraseAllDataTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = Theme.of(context).colorScheme.error;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.delete_forever_outlined, color: error),
      title: Text(l10n.eraseAllData, style: TextStyle(color: error)),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => const _EraseAllDataDialog(),
      ),
    );
  }
}

/// Asks for a typed word, not just a tap.
///
/// A second button in the same place is a confirmation a thumb gets through
/// by accident. Typing a word cannot be done without reading the dialog, and
/// this is the one action in the app with no way back.
class _EraseAllDataDialog extends ConsumerStatefulWidget {
  const _EraseAllDataDialog();

  @override
  ConsumerState<_EraseAllDataDialog> createState() =>
      _EraseAllDataDialogState();
}

class _EraseAllDataDialogState extends ConsumerState<_EraseAllDataDialog> {
  final _typed = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  Future<void> _exportFirst() async {
    setState(() => _busy = true);
    try {
      await runExportBackup(context, ref);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _erase() async {
    setState(() => _busy = true);
    final restart = ref.read(restartAppProvider);
    await ref.read(dataEraserProvider).eraseEverything();
    if (mounted) Navigator.of(context).pop();
    // The onboarding flags went with the rest, so the restart lands on it.
    await restart();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final word = l10n.eraseAllConfirmWord;
    final confirmed = _typed.text.trim().toUpperCase() == word;

    return AlertDialog(
      title: Text(l10n.eraseAllTitle),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.eraseAllBody),
              const SizedBox(height: 16),
              TextField(
                controller: _typed,
                enabled: !_busy,
                autocorrect: false,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: l10n.eraseAllTypeToConfirm(word),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        OutlinedButton(
          onPressed: _busy ? null : _exportFirst,
          child: Text(l10n.eraseAllExportFirst),
        ),
        FilledButton(
          onPressed: _busy || !confirmed ? null : _erase,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: Text(l10n.eraseAllAction),
        ),
      ],
    );
  }
}
