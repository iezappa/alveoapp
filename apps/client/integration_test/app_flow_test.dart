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
    // The tutorial is stored in the database rather than in preferences, so
    // it is marked seen there before the app boots. Otherwise the first-run
    // flow opens over the dashboard and this drives the wizard instead of
    // the app.
    final database = AppDatabase.connect();
    await SettingsRepository(database).set(tutorialSeenSettingKey, 'true');
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

    // Awaited: main() loads the database and every controller before it
    // calls runApp, so without this the first pump finds an empty tree.
    await app.main();
    await tester.pumpAndSettle();

    // Getting this far already covers what a widget test cannot: the database
    // opened, every controller loaded before the first frame, and the router
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
