import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/app/onboarding_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/main.dart';

Future<void> _pumpApp(
  WidgetTester tester,
  AppDatabase db, {
  bool firstRun = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        firstRunFlowEnabledProvider.overrideWithValue(firstRun),
      ],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// The care disclaimer opens the first launch, before the name prompt.
Future<void> _acceptDisclaimer(WidgetTester tester) async {
  await tester.tap(find.text('I understand'));
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('is the start screen and invites a breath', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    expect(find.text("Take a deep breath. You're safe here."), findsOneWidget);
    expect(find.text('No sessions scheduled'), findsOneWidget);
  });

  testWidgets('shows the next upcoming session with a Notes shortcut', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final now = DateTime.now();
    await SessionRepository(db)
        .create(scheduledFor: DateTime(now.year, now.month, now.day + 1, 10));

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

  testWidgets('first launch: asks for a name, then runs the tutorial', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db, firstRun: true);
    await _acceptDisclaimer(tester);

    expect(find.text("What's your name?"), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Alex');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Name saved, greeting updated, and the walkthrough takes over.
    expect(find.text("What's your name?"), findsNothing);
    expect(find.textContaining('Alex'), findsOneWidget);
    expect(find.text('Welcome to Alveo'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Alveo'), findsNothing);
  });

  testWidgets('the first-launch flow does not run a second time', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db, firstRun: true);
    await _acceptDisclaimer(tester);
    await tester.enterText(find.byType(TextField), 'Alex');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip')); // finishes the tutorial -> marked seen
    await tester.pumpAndSettle();

    // Re-pump from the same database: neither dialog returns.
    await _pumpApp(tester, db, firstRun: true);
    expect(find.text("What's your name?"), findsNothing);
    expect(find.text('Welcome to Alveo'), findsNothing);
  });
}
