import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Whether the app is currently behind the PIN lock screen.
///
/// After [_maxAttempts] wrong PINs the controller imposes a growing cooldown
/// (30s, doubling up to 5 min) during which [tryUnlock] refuses to check. The
/// cooldown deadline is persisted, so force-restarting the app does not reset
/// it.
class LockController extends Notifier<bool> {
  static const _maxAttempts = 5;
  static const _lockoutKey = 'security.pin_lockout_until';

  int _failed = 0;
  DateTime? _lockedOutUntil;

  @override
  bool build() => false;

  /// Called once at startup: locked iff a PIN has been set.
  Future<void> initialize() async {
    final stored = await ref.read(settingsRepositoryProvider).get(_lockoutKey);
    final ms = stored == null ? null : int.tryParse(stored);
    if (ms != null) {
      _lockedOutUntil = DateTime.fromMillisecondsSinceEpoch(ms);
    }
    state = await ref.read(pinServiceProvider).hasPin();
  }

  /// Re-lock when the app goes to the background — but only if a PIN exists.
  Future<void> lockIfProtected() async {
    if (await ref.read(pinServiceProvider).hasPin()) state = true;
  }

  void unlock() => state = false;

  /// How long the current cooldown still has to run, or [Duration.zero].
  Duration get lockoutRemaining {
    final until = _lockedOutUntil;
    if (until == null) return Duration.zero;
    final left = until.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  Future<bool> tryUnlock(String pin) async {
    if (lockoutRemaining > Duration.zero) return false;

    final ok = await ref.read(pinServiceProvider).verify(pin);
    if (ok) {
      _failed = 0;
      _lockedOutUntil = null;
      await ref.read(settingsRepositoryProvider).remove(_lockoutKey);
      state = false;
      return true;
    }

    _failed++;
    if (_failed >= _maxAttempts) {
      final seconds = (30 << (_failed - _maxAttempts)).clamp(30, 300);
      _lockedOutUntil = DateTime.now().add(Duration(seconds: seconds));
      await ref
          .read(settingsRepositoryProvider)
          .set(
            _lockoutKey,
            _lockedOutUntil!.millisecondsSinceEpoch.toString(),
          );
    }
    return false;
  }
}

final lockControllerProvider = NotifierProvider<LockController, bool>(
  LockController.new,
);

/// Whether a PIN is currently configured (for the settings screen).
final hasPinProvider = FutureProvider<bool>(
  (ref) => ref.watch(pinServiceProvider).hasPin(),
);
