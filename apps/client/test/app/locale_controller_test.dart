import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/app/locale_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';

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

  test('defaults to null (follow the device locale)', () {
    expect(container.read(localeControllerProvider), isNull);
  });

  test('setLocale updates state and persists across a reload', () async {
    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('es'));
    expect(container.read(localeControllerProvider), const Locale('es'));

    final reloaded = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(reloaded.dispose);
    await reloaded.read(localeControllerProvider.notifier).load();
    expect(reloaded.read(localeControllerProvider), const Locale('es'));
  });

  test('setLocale(null) clears the stored choice', () async {
    final notifier = container.read(localeControllerProvider.notifier);
    await notifier.setLocale(const Locale('en'));
    await notifier.setLocale(null);

    expect(container.read(localeControllerProvider), isNull);
    expect(
      await container.read(settingsRepositoryProvider).get(localeSettingKey),
      isNull,
    );
  });
}
