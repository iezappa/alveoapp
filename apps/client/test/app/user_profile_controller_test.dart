import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/app/user_profile_controller.dart';
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

  test('starts loading, then resolves to null when never asked', () async {
    expect(
      container.read(userProfileControllerProvider),
      const AsyncValue<String?>.loading(),
    );

    await container.read(userProfileControllerProvider.notifier).load();
    expect(container.read(userProfileControllerProvider).value, isNull);
  });

  test('setName trims, updates state and persists across a reload', () async {
    await container
        .read(userProfileControllerProvider.notifier)
        .setName('  Sam  ');
    expect(container.read(userProfileControllerProvider).value, 'Sam');

    final reloaded = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(reloaded.dispose);
    await reloaded.read(userProfileControllerProvider.notifier).load();
    expect(reloaded.read(userProfileControllerProvider).value, 'Sam');
  });

  test('an empty answer is stored so the prompt does not return', () async {
    await container.read(userProfileControllerProvider.notifier).setName('   ');
    expect(container.read(userProfileControllerProvider).value, '');
    expect(
      await container.read(settingsRepositoryProvider).get(userNameSettingKey),
      '',
    );
  });
}
