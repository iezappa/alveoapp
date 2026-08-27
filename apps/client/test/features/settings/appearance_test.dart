import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/app/theme.dart';
import 'package:terapia/app/theme_controller.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/main.dart';

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
        child: const TerapiaApp(),
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
