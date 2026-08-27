import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/security/pin_service.dart';
import '../../l10n/app_localizations.dart';

final _digitsOnly = [FilteringTextInputFormatter.digitsOnly];

/// Prompts for one PIN (e.g. the current one). Returns null if cancelled.
Future<String?> promptExistingPin(BuildContext context, String title) {
  return showDialog<String>(
    context: context,
    builder: (_) => _SinglePinDialog(title: title),
  );
}

/// Prompts for a new PIN plus confirmation, validating length and match.
/// Returns the new PIN, or null if cancelled.
Future<String?> promptNewPin(BuildContext context, String title) {
  return showDialog<String>(
    context: context,
    builder: (_) => _NewPinDialog(title: title),
  );
}

class _SinglePinDialog extends StatefulWidget {
  const _SinglePinDialog({required this.title});

  final String title;

  @override
  State<_SinglePinDialog> createState() => _SinglePinDialogState();
}

class _SinglePinDialogState extends State<_SinglePinDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        inputFormatters: _digitsOnly,
        maxLength: 8,
        decoration: InputDecoration(
          counterText: '',
          labelText: l10n.pinCurrentLabel,
        ),
        onSubmitted: (_) => Navigator.pop(context, _controller.text),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(l10n.saveButton),
        ),
      ],
    );
  }
}

class _NewPinDialog extends StatefulWidget {
  const _NewPinDialog({required this.title});

  final String title;

  @override
  State<_NewPinDialog> createState() => _NewPinDialogState();
}

class _NewPinDialogState extends State<_NewPinDialog> {
  final _pin = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    if (_pin.text.length < PinService.minLength) {
      setState(() => _error = l10n.pinTooShort);
      return;
    }
    if (_pin.text != _confirm.text) {
      setState(() => _error = l10n.pinMismatch);
      return;
    }
    Navigator.pop(context, _pin.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pin,
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: _digitsOnly,
            maxLength: 8,
            decoration: InputDecoration(
              counterText: '',
              labelText: l10n.pinNewLabel,
            ),
          ),
          TextField(
            controller: _confirm,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: _digitsOnly,
            maxLength: 8,
            decoration: InputDecoration(
              counterText: '',
              labelText: l10n.pinConfirmLabel,
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.saveButton)),
      ],
    );
  }
}
