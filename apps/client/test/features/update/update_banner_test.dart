import 'package:alveo/app/lock_controller.dart';
import 'package:alveo/app/onboarding_controller.dart';
import 'package:alveo/app/user_profile_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/security/pin_service.dart';
import 'package:alveo/domain/release_notes/app_version.dart';
import 'package:alveo/domain/update/update_info.dart';
import 'package:alveo/features/update/update_providers.dart';
import 'package:alveo/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUpdates implements UpdateService {
  _FakeUpdates(this.info);
  final UpdateInfo? info;
  @override
  Future<UpdateInfo?> check() async => info;
}

final _newer = UpdateInfo(
  latest: const AppVersion(9, 0, 0),
  url: Uri.parse('https://example.test/release'),
);

final _schemaChange = UpdateInfo(
  latest: const AppVersion(9, 0, 0),
  url: Uri.parse('https://example.test/release'),
  schemaChange: true,
);

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting();
    final settings = DriftSettingsRepository(db);
    for (final key in [
      disclaimerAcceptedSettingKey,
      backupNoticeAcceptedSettingKey,
      tutorialSeenSettingKey,
    ]) {
      await settings.set(key, 'true');
    }
    await settings.set(userNameSettingKey, 'Ana');
  });
  tearDown(() => db.close());

  Future<ProviderContainer> pump(WidgetTester tester, UpdateInfo? info) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        updateServiceProvider.overrideWith((ref) async => _FakeUpdates(info)),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const AlveoApp()),
    );
    for (var i = 0; i < 4; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pumpAndSettle();
    }
    return container;
  }

  testWidgets('offers a newer version, and stays out of the way', (
    tester,
  ) async {
    await pump(tester, _newer);
    expect(find.text('A new version is available'), findsOneWidget);
    expect(find.text('Version 9.0.0 is available.'), findsOneWidget);
    expect(
      find.textContaining('changes how your data is stored'),
      findsNothing,
    );
  });

  testWidgets('a schema change asks for a backup first', (tester) async {
    await pump(tester, _schemaChange);
    expect(
      find.textContaining('changes how your data is stored'),
      findsOneWidget,
    );
    expect(find.text('Export'), findsOneWidget);
  });

  testWidgets('says nothing when there is nothing new', (tester) async {
    await pump(tester, null);
    expect(find.text('A new version is available'), findsNothing);
  });

  testWidgets('"Not now" hides it until the next version', (tester) async {
    final container = await pump(tester, _newer);
    await tester.tap(find.text('Not now'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pumpAndSettle();

    expect(find.text('A new version is available'), findsNothing);
    expect(
      await tester.runAsync(
        () => container
            .read(settingsRepositoryProvider)
            .get(dismissedUpdateSettingKey),
      ),
      '9.0.0',
    );
  });

  testWidgets('a locked app shows the lock screen, never the banner', (
    tester,
  ) async {
    await PinService(DriftSettingsRepository(db)).setPin('1234');
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        updateServiceProvider.overrideWith((ref) async => _FakeUpdates(_newer)),
      ],
    );
    addTearDown(container.dispose);
    await container.read(lockControllerProvider.notifier).initialize();

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const AlveoApp()),
    );
    for (var i = 0; i < 4; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pumpAndSettle();
    }

    expect(container.read(lockControllerProvider), isTrue);
    expect(find.text('A new version is available'), findsNothing);
  });
}
