import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/lock_controller.dart';
import '../../l10n/app_localizations.dart';

/// Full-screen PIN gate shown while the app is locked.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _error;
  bool _checking = false;
  Duration _lockout = Duration.zero;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _syncLockout();
  }

  @override
  void dispose() {
    _tick?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _syncLockout() {
    final remaining = ref
        .read(lockControllerProvider.notifier)
        .lockoutRemaining;
    setState(() => _lockout = remaining);
    if (remaining > Duration.zero) {
      _tick ??= Timer.periodic(const Duration(seconds: 1), (t) {
        final left = ref.read(lockControllerProvider.notifier).lockoutRemaining;
        if (!mounted) return;
        setState(() => _lockout = left);
        if (left <= Duration.zero) {
          t.cancel();
          _tick = null;
        }
      });
    }
  }

  Future<void> _submit() async {
    final pin = _controller.text;
    if (pin.length < 4 || _checking || _lockout > Duration.zero) return;

    setState(() {
      _checking = true;
      _error = null;
    });

    final ok = await ref.read(lockControllerProvider.notifier).tryUnlock(pin);
    if (ok || !mounted) return;

    setState(() {
      _checking = false;
      _controller.clear();
      _error = AppLocalizations.of(context).pinWrong;
    });
    _syncLockout();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lockedOut = _lockout > Duration.zero;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  l10n.pinEnterTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  obscureText: true,
                  enabled: !lockedOut,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 8,
                  textAlign: TextAlign.center,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    counterText: '',
                    border: const OutlineInputBorder(),
                    errorText: lockedOut
                        ? l10n.pinLockedOut(_lockout.inSeconds + 1)
                        : _error,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: (_checking || lockedOut) ? null : _submit,
                  child: Text(l10n.pinUnlock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
