import 'package:alveo/app/onboarding_controller.dart';
import 'package:alveo/app/user_profile_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _disclaimerTitle = 'Before you start';

void main() {
  late AppDatabase db;
  late DriftSettingsRepository settings;

  setUp(() {
    db = AppDatabase.forTesting();
    settings = DriftSettingsRepository(db);
  });
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

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('a new user accepts it before anything else', (tester) async {
    await pumpApp(tester);

    expect(find.text(_disclaimerTitle), findsOneWidget);
    expect(
      find.textContaining('not a substitute for professional care'),
      findsOneWidget,
    );
    expect(find.textContaining('call 911'), findsOneWidget);
    expect(find.textContaining('Línea 135'), findsOneWidget);
    expect(find.text("What's your name?"), findsNothing);

    await tester.tap(find.text('I understand'));
    await settle(tester);

    expect(await settings.get(disclaimerAcceptedSettingKey), 'true');
    expect(find.text("What's your name?"), findsOneWidget);
  });

  testWidgets('does not close without accepting', (tester) async {
    await pumpApp(tester);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text(_disclaimerTitle), findsOneWidget);
  });

  testWidgets('someone onboarded before it sees it once', (tester) async {
    await settings.set(tutorialSeenSettingKey, 'true');
    await settings.set(userNameSettingKey, 'Ana');
    await settings.set(backupNoticeAcceptedSettingKey, 'true');

    await pumpApp(tester);
    expect(find.text(_disclaimerTitle), findsOneWidget);

    await tester.tap(find.text('I understand'));
    await settle(tester);
    expect(find.text(_disclaimerTitle), findsNothing);
  });

  testWidgets('is not shown again once accepted', (tester) async {
    await settings.set(tutorialSeenSettingKey, 'true');
    await settings.set(userNameSettingKey, 'Ana');
    await settings.set(backupNoticeAcceptedSettingKey, 'true');
    await settings.set(disclaimerAcceptedSettingKey, 'true');

    await pumpApp(tester);

    expect(find.text(_disclaimerTitle), findsNothing);
  });
}
