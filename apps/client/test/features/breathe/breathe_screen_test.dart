import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/features/breathe/breathe_screen.dart';
import 'package:alveo/l10n/app_localizations.dart';

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BreatheScreen(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('starts a session and then ends it', (tester) async {
    await _pump(tester);

    expect(find.text('Start session'), findsOneWidget);

    await tester.tap(find.text('Start session'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Breathe in'), findsOneWidget);
    expect(find.text('End session'), findsOneWidget);
    expect(find.text('REMAINING'), findsOneWidget);

    // End it so the repeating animation leaves no live timer.
    await tester.tap(find.text('End session'));
    await tester.pumpAndSettle();

    expect(find.text('Start session'), findsOneWidget);
  });

  testWidgets('offers box and 4-7-8 patterns before starting', (tester) async {
    await _pump(tester);

    expect(find.text('Box · 4·4·4·4'), findsOneWidget);
    expect(find.text('Calm · 4·7·8'), findsOneWidget);
  });

  testWidgets('keeps its content in a narrow column, not full-bleed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _pump(tester);

    final constrained = tester.widgetList<ConstrainedBox>(
      find.descendant(
        of: find.byType(BreatheScreen),
        matching: find.byType(ConstrainedBox),
      ),
    );
    expect(
      constrained.any((c) => c.constraints.maxWidth <= 360),
      isTrue,
      reason: 'the breathing UI should sit in a phone-width column',
    );
  });
}
