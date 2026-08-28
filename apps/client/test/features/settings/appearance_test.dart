import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/app/theme.dart';
import 'package:alveo/app/theme_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/main.dart';

void main() {
  testWidgets('the appearance controls change theme mode and accent', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(container.read(themeControllerProvider).mode, ThemeMode.dark);

    await tester.tap(find.byKey(const ValueKey('accent-violet')));
    await tester.pumpAndSettle();
    expect(container.read(themeControllerProvider).accent, AppAccent.violet);
  });
}
