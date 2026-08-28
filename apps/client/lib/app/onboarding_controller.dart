import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Settings key recording that the first-run tutorial has been shown once.
const tutorialSeenSettingKey = 'onboarding.tutorial_seen';

/// Tracks whether the user has seen the walkthrough. `AsyncLoading` until
/// [load] runs so the dashboard can tell "not loaded" from "not seen".
class OnboardingController extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() => const AsyncValue.loading();

  /// Loads the persisted flag. `main()` calls this before `runApp`; it is
  /// safe to call again from a widget test that skips the bootstrap.
  Future<void> load() async {
    final stored = await ref
        .read(settingsRepositoryProvider)
        .get(tutorialSeenSettingKey);
    state = AsyncValue.data(stored == 'true');
  }

  /// Records that the walkthrough has been shown, so it is not shown again
  /// automatically. Re-opening it from Settings does not call this.
  Future<void> markSeen() async {
    await ref
        .read(settingsRepositoryProvider)
        .set(tutorialSeenSettingKey, 'true');
    state = const AsyncValue.data(true);
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, AsyncValue<bool>>(
      OnboardingController.new,
    );

/// Whether the dashboard runs the first-launch flow (name prompt + tutorial)
/// on its own. `main()` overrides this to `true`; it stays `false` by default
/// so widget tests are not interrupted by a modal barrier.
final firstRunFlowEnabledProvider = Provider<bool>((ref) => false);
