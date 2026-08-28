import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/main.dart';

Future<void> _pumpApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('is the start screen and invites a breath', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    expect(
      find.text("Take a deep breath. You're safe here."),
      findsOneWidget,
    );
    expect(find.text('No sessions scheduled'), findsOneWidget);
  });

  testWidgets('shows the next upcoming session with a Notes shortcut', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final now = DateTime.now();
    await SessionRepository(db).create(
      scheduledFor: DateTime(now.year, now.month, now.day + 1, 10),
    );

    await _pumpApp(tester, db);

    expect(find.textContaining('Tomorrow'), findsOneWidget);

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    // The session editor opened (its tab bar carries the same word).
    expect(find.text('Session'), findsOneWidget);
  });

  testWidgets('the Breathe button opens the breathing screen', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    await tester.tap(find.text('Breathe'));
    await tester.pumpAndSettle();

    expect(find.text('Start session'), findsOneWidget);
  });

  testWidgets('tapping the quote card opens the library', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    await tester.tap(find.byIcon(Icons.format_quote));
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget);
  });
}
