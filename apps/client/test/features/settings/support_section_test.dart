import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/main.dart';

void main() {
  testWidgets('Settings shows the support section with both donation links', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const AlveoApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('support-cafecito')),
      200,
    );

    expect(find.byKey(const ValueKey('support-cafecito')), findsOneWidget);
    expect(find.byKey(const ValueKey('support-patreon')), findsOneWidget);
    expect(find.text('Support my projects'), findsOneWidget);
  });
}
