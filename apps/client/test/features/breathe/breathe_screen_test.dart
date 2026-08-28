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
  testWidgets('starts paced breathing and then stops it', (tester) async {
    await _pump(tester);

    expect(find.text('Ready when you are'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Breathe in'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);

    // Stop before the test ends so the repeating animation has no live timer.
    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();

    expect(find.text('Ready when you are'), findsOneWidget);
  });

  testWidgets('offers box and 4-7-8 patterns', (tester) async {
    await _pump(tester);

    expect(find.text('Box · 4·4·4·4'), findsOneWidget);
    expect(find.text('Calm · 4·7·8'), findsOneWidget);
  });
}
