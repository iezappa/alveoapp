import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/app/onboarding_controller.dart';
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

  test('loads as "not seen" until marked', () async {
    expect(
      container.read(onboardingControllerProvider),
      const AsyncValue<bool>.loading(),
    );

    await container.read(onboardingControllerProvider.notifier).load();
    expect(container.read(onboardingControllerProvider).value, isFalse);
  });

  test('markSeen persists across a reload', () async {
    await container.read(onboardingControllerProvider.notifier).markSeen();
    expect(container.read(onboardingControllerProvider).value, isTrue);

    final reloaded = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(reloaded.dispose);
    await reloaded.read(onboardingControllerProvider.notifier).load();
    expect(reloaded.read(onboardingControllerProvider).value, isTrue);
  });
}
