import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import 'theme.dart';

class ThemeSettings {
  const ThemeSettings({required this.mode, required this.accent});

  final ThemeMode mode;
  final AppAccent accent;

  ThemeSettings copyWith({ThemeMode? mode, AppAccent? accent}) =>
      ThemeSettings(mode: mode ?? this.mode, accent: accent ?? this.accent);
}

/// Holds the user's theme mode (system/light/dark) and accent colour, both
/// persisted in [AppSettings]. Loaded once at startup.
class ThemeController extends Notifier<ThemeSettings> {
  static const modeKey = 'ui.theme_mode';
  static const accentKey = 'ui.accent';

  @override
  ThemeSettings build() =>
      const ThemeSettings(mode: ThemeMode.system, accent: AppAccent.green);

  Future<void> load() async {
    final settings = ref.read(settingsRepositoryProvider);
    final mode = switch (await settings.get(modeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final accentName = await settings.get(accentKey);
    final accent = AppAccent.values.firstWhere(
      (a) => a.name == accentName,
      orElse: () => AppAccent.green,
    );
    state = ThemeSettings(mode: mode, accent: accent);
  }

  Future<void> setMode(ThemeMode mode) async {
    await ref.read(settingsRepositoryProvider).set(modeKey, mode.name);
    state = state.copyWith(mode: mode);
  }

  Future<void> setAccent(AppAccent accent) async {
    await ref.read(settingsRepositoryProvider).set(accentKey, accent.name);
    state = state.copyWith(accent: accent);
  }
}

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeSettings>(ThemeController.new);
