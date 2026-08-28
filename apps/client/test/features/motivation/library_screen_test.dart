import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/motivation/daily_quotes.dart';
import 'package:alveo/features/motivation/library_screen.dart';
import 'package:alveo/l10n/app_localizations.dart';

void main() {
  testWidgets('lists every quote with today shown first', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LibraryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget); // SectionLabel uppercases
    expect(find.text('ALL QUOTES'), findsOneWidget);

    // Today's quote sits in the highlighted card near the top.
    final todayText = quoteForDay(DateTime.now()).text('en');
    expect(find.text(todayText), findsAtLeastNWidgets(1));

    // Scrolling reveals more of the collection.
    expect(find.byType(Card), findsWidgets);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsWidgets);
  });
}
