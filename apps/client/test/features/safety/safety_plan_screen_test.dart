import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/safety_plan_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

void main() {
  testWidgets('edits the plan from the dashboard card and persists it', (
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

    await tester.scrollUntilVisible(
      find.text('Safety plan'), // dashboard card, near the bottom
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _centre(tester, find.text('Safety plan'));
    await tester.tap(find.text('Safety plan'));
    await tester.pumpAndSettle();

    // First field is "Warning signs".
    await tester.enterText(find.byType(TextField).first, 'shutting down');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final loaded = await DriftSafetyPlanRepository(DriftSettingsRepository(db))
        .load();
    expect(loaded.warningSigns, 'shutting down');
  });

  testWidgets('keeps the edits when the plan could not be saved', (
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
    await tester.scrollUntilVisible(
      find.text('Safety plan'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _centre(tester, find.text('Safety plan'));
    await tester.tap(find.text('Safety plan'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'shutting down');

    await refuseWrites(db, 'app_settings');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(find.text(saveFailedMessage), findsOneWidget);
    expect(find.text('shutting down'), findsWidgets);
  });
}

/// Scrolls [finder] to the middle of the viewport, clear of the bottom bar
/// that would otherwise swallow the tap.
Future<void> _centre(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}
