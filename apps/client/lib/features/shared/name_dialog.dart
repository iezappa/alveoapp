import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/user_profile_controller.dart';
import '../../l10n/app_localizations.dart';

/// Prompts for the user's display name and persists it. Used for the
/// first-launch welcome and from Settings.
///
/// When [dismissible] is false the dialog has no barrier dismiss and no
/// cancel action, so the first-launch flow always resolves to a stored value
/// (possibly empty) and never asks twice.
Future<void> promptForName(
  BuildContext context,
  WidgetRef ref, {
  String? initial,
  bool dismissible = true,
}) async {
  final answer = await showDialog<String>(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) =>
        _NameDialog(initial: initial ?? '', dismissible: dismissible),
  );

  if (answer == null) return; // dismissed without saving
  await ref.read(userProfileControllerProvider.notifier).setName(answer);
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial, required this.dismissible});

  final String initial;
  final bool dismissible;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.namePromptTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(labelText: l10n.namePromptLabel),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        if (widget.dismissible)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l10n.saveButton),
        ),
      ],
    );
  }
}
