import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/features/insights/insights_screen.dart';
import 'package:alveo/features/insights/mood_calendar.dart';
import 'package:alveo/l10n/app_localizations.dart';

Future<void> _pump(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: InsightsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the empty state with no check-ins', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pump(tester, db);

    expect(find.text('Not enough check-ins yet'), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);
    // The calendar still renders (an all-grey month).
    expect(find.byType(MoodCalendar), findsOneWidget);
  });

  testWidgets('charts the average once there is data', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final now = DateTime.now();
    await DriftMoodRepository(db).add(mood: 4, occurredAt: now);
    await DriftMoodRepository(db)
        .add(mood: 2, occurredAt: now.subtract(const Duration(days: 3)));

    await _pump(tester, db);

    expect(find.textContaining('Average'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);

    await tester.tap(find.text('90 days'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
  });
}
