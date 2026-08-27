import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Settings key under which the explicit UI language choice is stored.
const localeSettingKey = 'ui.locale';

/// Holds the user's explicit UI language choice.
///
/// `null` means "no choice yet — follow the device locale". Once the user
/// picks a language it is persisted and survives restarts.
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  /// Loads the persisted choice. Call once during startup before `runApp`.
  Future<void> load() async {
    final code = await ref
        .read(settingsRepositoryProvider)
        .get(localeSettingKey);
    state = code == null ? null : Locale(code);
  }

  /// Persists [locale] as the UI language. Pass `null` to clear the choice
  /// and fall back to the device locale.
  Future<void> setLocale(Locale? locale) async {
    final settings = ref.read(settingsRepositoryProvider);
    if (locale == null) {
      await settings.remove(localeSettingKey);
    } else {
      await settings.set(localeSettingKey, locale.languageCode);
    }
    state = locale;
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);
