import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Whether the app is currently behind the PIN lock screen.
class LockController extends Notifier<bool> {
  @override
  bool build() => false;

  /// Called once at startup: locked iff a PIN has been set.
  Future<void> initialize() async {
    state = await ref.read(pinServiceProvider).hasPin();
  }

  /// Re-lock when the app goes to the background — but only if a PIN exists.
  Future<void> lockIfProtected() async {
    if (await ref.read(pinServiceProvider).hasPin()) state = true;
  }

  void unlock() => state = false;

  Future<bool> tryUnlock(String pin) async {
    final ok = await ref.read(pinServiceProvider).verify(pin);
    if (ok) state = false;
    return ok;
  }
}

final lockControllerProvider = NotifierProvider<LockController, bool>(
  LockController.new,
);

/// Whether a PIN is currently configured (for the settings screen).
final hasPinProvider = FutureProvider<bool>(
  (ref) => ref.watch(pinServiceProvider).hasPin(),
);
