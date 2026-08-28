import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/app/lock_controller.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/data/repositories/settings_repository.dart';
import 'package:terapia/data/security/pin_service.dart';
import 'package:terapia/main.dart';

void main() {
  testWidgets('a configured PIN gates the app until it is entered', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await PinService(SettingsRepository(db)).setPin('1234');

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    await container.read(lockControllerProvider.notifier).initialize();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TerapiaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter your PIN'), findsOneWidget);
    expect(find.text('Timeline'), findsNothing);

    await tester.enterText(find.byType(TextField), '9999');
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.text('Wrong PIN'), findsOneWidget);
    expect(find.text('Timeline'), findsNothing);

    await tester.enterText(find.byType(TextField), '1234');
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    // The dashboard (the start screen) is now visible.
    expect(
      find.text("Take a deep breath. You're safe here."),
      findsOneWidget,
    );
  });
}
