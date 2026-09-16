// The app driven end to end, on the real thing: its own database on disk,
// its own settings, its own router and lock. The widget tests build one
// screen with everything faked around it, so nothing there would notice a
// database that fails to open on a real platform, a migration that throws on
// first launch, or a route that no longer resolves.
//
//   flutter test integration_test -d linux
//
// On a headless machine, wrap it: `xvfb-run -a flutter test integration_test
// -d linux`. The Linux shell is a real GTK application and wants a display
// even when nobody is watching.
import 'package:flutter/material.dart';

import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/app/onboarding_controller.dart';
import 'package:alveo/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // The tutorial and the one-time notices are stored in the database rather
    // than in preferences, so they are marked done there before the app
    // boots. Otherwise the launch flow opens over the dashboard and this
    // drives the dialogs instead of the app.
    final database = AppDatabase.connect();
    final settings = SettingsRepository(database);
    await settings.set(tutorialSeenSettingKey, 'true');
    await settings.set(disclaimerAcceptedSettingKey, 'true');
    await settings.set(backupNoticeAcceptedSettingKey, 'true');
    await database.close();
  });

  testWidgets('boots into the dashboard and moves between sections', (
    tester,
  ) async {
    // Phone-sized on purpose: the shell shows a rail on a wide window and a
    // bottom bar on a narrow one, and this walks the bottom bar. The desktop
    // window these run in would otherwise pick the other layout.
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // main() hands the loading to AppRestartHost, which opens the database
    // and loads every controller before it builds the app. That is real I/O,
    // which pumping frames alone does not wait for.
    await app.main();
    for (var i = 0; i < 100; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      if (find.byType(NavigationDestination).evaluate().isNotEmpty) break;
    }

    // Getting this far already covers what a widget test cannot: the database
    // opened, every controller loaded before the app was built, and the router
    // resolved its initial route.
    expect(find.byType(Scaffold), findsWidgets);

    // The bottom navigation is the app's own spine. Walking it is what
    // catches a route that stopped resolving after a refactor.
    final destinations = find.byType(NavigationDestination);
    expect(
      destinations,
      findsWidgets,
      reason: 'the dashboard should offer its sections',
    );

    for (var i = 0; i < 3; i++) {
      await tester.tap(destinations.at(i));
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'section $i should open without throwing',
      );
    }
  });
}
