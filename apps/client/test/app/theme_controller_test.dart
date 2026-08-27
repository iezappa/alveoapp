import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/app/theme.dart';
import 'package:terapia/app/theme_controller.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.forTesting();
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
  });
  tearDown(() {
    container.dispose();
    db.close();
  });

  test('defaults to system mode and the green accent', () {
    final settings = container.read(themeControllerProvider);
    expect(settings.mode, ThemeMode.system);
    expect(settings.accent, AppAccent.green);
  });

  test('mode and accent persist across a reload', () async {
    final notifier = container.read(themeControllerProvider.notifier);
    await notifier.setMode(ThemeMode.dark);
    await notifier.setAccent(AppAccent.violet);

    expect(container.read(themeControllerProvider).mode, ThemeMode.dark);
    expect(container.read(themeControllerProvider).accent, AppAccent.violet);

    final reloaded = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(reloaded.dispose);
    await reloaded.read(themeControllerProvider.notifier).load();

    expect(reloaded.read(themeControllerProvider).mode, ThemeMode.dark);
    expect(reloaded.read(themeControllerProvider).accent, AppAccent.violet);
  });
}
