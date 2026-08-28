import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/thought_record_repository.dart';
import 'package:alveo/features/cbt/thought_record_editor_screen.dart';
import 'package:alveo/main.dart';

Finder _editorFields() => find.descendant(
  of: find.byType(ThoughtRecordEditorScreen),
  matching: find.byType(TextField),
);

Future<void> _openTools(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Tools')); // navigation destination
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('empty state, then creates a thought record', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openTools(tester, db);
    expect(find.text('No thought records yet'), findsOneWidget);

    await tester.tap(find.byTooltip('Use a tool'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New thought record')); // tool menu
    await tester.pumpAndSettle();

    await tester.enterText(_editorFields().at(0), 'Meeting ran long');
    await tester.enterText(_editorFields().at(1), 'I always mess up');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final all = await ThoughtRecordRepository(db).getAll();
    expect(all, hasLength(1));
    expect(all.single.situation, 'Meeting ran long');
    expect(all.single.automaticThought, 'I always mess up');
    expect(all.single.beliefBefore, 50); // slider default

    // Back on the tools list, now showing the record.
    expect(find.text('Meeting ran long'), findsOneWidget);
  });

  testWidgets('wide layout previews the selected record in place', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await ThoughtRecordRepository(db).create(
      occurredAt: DateTime(2026, 8, 20),
      situation: 'Ran into an old friend',
      automaticThought: 'They must think I have not changed',
    );

    await _openTools(tester, db);

    expect(find.text('Pick a record to see it here'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Ran into an old friend'));
    await tester.pumpAndSettle();

    expect(
      find.text('They must think I have not changed'),
      findsOneWidget,
    );
    expect(find.text('Edit'), findsOneWidget);
  });
}
