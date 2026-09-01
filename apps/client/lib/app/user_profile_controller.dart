import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Settings key under which the user's display name is stored.
const userNameSettingKey = 'profile.name';

/// Holds the user's display name, shown in the dashboard greeting.
///
/// The state is an [AsyncValue] so callers can tell "not loaded yet" apart
/// from "loaded, and there is no name". A data value of `null` means the user
/// has never been asked — the dashboard shows a one-time prompt on first
/// launch. An empty string means "asked, left blank": the greeting stays
/// name-less and the prompt does not return.
class UserProfileController extends Notifier<AsyncValue<String?>> {
  @override
  AsyncValue<String?> build() => const AsyncValue.loading();

  /// Loads the persisted name. `main()` calls this before `runApp`; it is
  /// safe to call again (e.g. from a widget test that skips the bootstrap).
  Future<void> load() async {
    final stored = await ref
        .read(settingsRepositoryProvider)
        .get(userNameSettingKey);
    state = AsyncValue.data(stored);
  }

  /// Persists [name] (trimmed). Pass an empty string to record that the user
  /// was asked but chose not to give a name.
  Future<void> setName(String name) async {
    final trimmed = name.trim();
    await ref.read(settingsRepositoryProvider).set(userNameSettingKey, trimmed);
    state = AsyncValue.data(trimmed);
  }
}

final userProfileControllerProvider =
    NotifierProvider<UserProfileController, AsyncValue<String?>>(
      UserProfileController.new,
    );
