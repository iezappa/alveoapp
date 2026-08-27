import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/main.dart';

void main() {
  testWidgets('language toggle in settings switches UI copy to Spanish',
      (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const TerapiaApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Timeline is the start screen (its FAB is unique to it).
    expect(find.text('New check-in'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Spanish'), findsOneWidget); // language segment, in English
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();

    // The segment now shows its Spanish label.
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Spanish'), findsNothing);
  });
}
