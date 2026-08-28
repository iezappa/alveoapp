import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/main.dart';

Future<void> _pumpApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Timeline')); // leave the dashboard start screen
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists a saved mood entry with its note', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await MoodRepository(db)
        .add(mood: 4, occurredAt: DateTime(2026, 8, 20, 9), note: 'ok day');

    await _pumpApp(tester, db);

    expect(find.text('Mood 4/5'), findsOneWidget);
    expect(find.textContaining('ok day'), findsOneWidget);
  });

  testWidgets('shows the empty state when nothing is logged', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    expect(find.text('Nothing logged yet'), findsOneWidget);
  });

  testWidgets('wide layout previews the selected item in place', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await MoodRepository(db).add(
      mood: 3,
      occurredAt: DateTime(2026, 8, 20, 9),
      note: 'a steady afternoon',
    );

    await _pumpApp(tester, db);

    expect(find.text('Pick a record to see it here'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Mood 3/5'));
    await tester.pumpAndSettle();

    // The preview shows the note; a mood entry has no Edit hand-off.
    expect(find.text('a steady afternoon'), findsOneWidget);
    expect(find.text('Edit'), findsNothing);
  });
}
