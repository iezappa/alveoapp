import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/safety_plan_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/main.dart';

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

    final loaded = await SafetyPlanRepository(SettingsRepository(db)).load();
    expect(loaded.warningSigns, 'shutting down');
  });
}

/// Scrolls [finder] to the middle of the viewport, clear of the bottom bar
/// that would otherwise swallow the tap.
Future<void> _centre(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}
