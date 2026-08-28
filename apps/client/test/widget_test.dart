import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/main.dart';

void main() {
  testWidgets('language toggle in settings switches UI copy to Spanish', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // The dashboard is the start screen.
    expect(
      find.text("Take a deep breath. You're safe here."),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(
      find.text('Spanish'),
      findsOneWidget,
    ); // language segment, in English
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();

    // The segment now shows its Spanish label.
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Spanish'), findsNothing);
  });
}
