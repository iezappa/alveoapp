import 'package:alveo/app/onboarding_controller.dart';
import 'package:alveo/app/user_profile_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting());
  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          firstRunFlowEnabledProvider.overrideWithValue(true),
        ],
        child: const AlveoApp(),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('someone onboarded before the notice sees it once', (
    tester,
  ) async {
    final settings = SettingsRepository(db);
    await settings.set(tutorialSeenSettingKey, 'true');
    await settings.set(userNameSettingKey, 'Ana');

    await pumpApp(tester);

    expect(find.text('Your data lives only on this device'), findsOneWidget);

    // Only accepting closes it.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('Your data lives only on this device'), findsOneWidget);

    await tester.tap(find.text("Got it, I'll back up"));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Your data lives only on this device'), findsNothing);
    expect(await settings.get(backupNoticeAcceptedSettingKey), 'true');
  });

  testWidgets('is not shown again once accepted', (tester) async {
    final settings = SettingsRepository(db);
    await settings.set(tutorialSeenSettingKey, 'true');
    await settings.set(userNameSettingKey, 'Ana');
    await settings.set(backupNoticeAcceptedSettingKey, 'true');

    await pumpApp(tester);

    expect(find.text('Your data lives only on this device'), findsNothing);
  });

  testWidgets('a new user meets it at the end of onboarding', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'Ana');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Your data lives only on this device'), findsOneWidget);
  });
}
