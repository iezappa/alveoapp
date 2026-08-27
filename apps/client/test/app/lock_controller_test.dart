import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/app/lock_controller.dart';
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

  test('initialize leaves the app unlocked when no PIN is set', () async {
    await container.read(lockControllerProvider.notifier).initialize();
    expect(container.read(lockControllerProvider), isFalse);
  });

  test('initialize locks the app when a PIN exists', () async {
    await container.read(pinServiceProvider).setPin('1234');
    await container.read(lockControllerProvider.notifier).initialize();
    expect(container.read(lockControllerProvider), isTrue);
  });

  test('tryUnlock: a wrong PIN stays locked, the right one unlocks', () async {
    await container.read(pinServiceProvider).setPin('1234');
    final notifier = container.read(lockControllerProvider.notifier);
    await notifier.initialize();

    expect(await notifier.tryUnlock('0000'), isFalse);
    expect(container.read(lockControllerProvider), isTrue);

    expect(await notifier.tryUnlock('1234'), isTrue);
    expect(container.read(lockControllerProvider), isFalse);
  });

  test('lockIfProtected only locks when a PIN is set', () async {
    final notifier = container.read(lockControllerProvider.notifier);

    await notifier.lockIfProtected();
    expect(container.read(lockControllerProvider), isFalse);

    await container.read(pinServiceProvider).setPin('1234');
    await notifier.lockIfProtected();
    expect(container.read(lockControllerProvider), isTrue);
  });
}
