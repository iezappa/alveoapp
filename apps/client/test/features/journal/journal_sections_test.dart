import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/domain/journal/journal_section.dart';
import 'package:alveo/features/journal/journal_editor_screen.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

Finder _editorField() => find.descendant(
  of: find.byType(JournalEditorScreen),
  matching: find.byType(TextField),
);

Future<void> _openJournal(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Journal')); // navigation destination
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('offers a filter chip for every section', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openJournal(tester, db);

    expect(find.widgetWithText(FilterChip, 'One-liners'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Creative'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Win log'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Therapy'), findsOneWidget);
  });

  testWidgets('adding while a section is selected files the entry there', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openJournal(tester, db);

    await tester.tap(find.byTooltip('New entry')); // "+" in the list pane
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Creative')); // section menu
    await tester.pumpAndSettle();

    await tester.enterText(_editorField().last, 'a poem idea');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final creative = await DriftJournalRepository(db)
        .getBySection(JournalSection.creative);
    expect(creative, hasLength(1));
    expect(creative.single.bodyMarkdown, 'a poem idea');
  });

  testWidgets('wide layout previews the selected entry in place', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftJournalRepository(db).create(
      bodyMarkdown: 'first light through the window',
      entryDate: DateTime(2026, 8, 20),
      title: 'Morning',
    );

    await _openJournal(tester, db);

    await tester.tap(find.widgetWithText(ListTile, 'Morning'));
    await tester.pumpAndSettle();

    expect(find.text('first light through the window'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    // Delete it from the preview, confirming the dialog.
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(await DriftJournalRepository(db).getAll(), isEmpty);
    expect(find.text('Pick a record to see it here'), findsOneWidget);
  });

  // A refused delete used to vanish: the journal entry stayed with nothing on screen
  // to say so, and the user walked away believing it was gone.
  testWidgets('says so when the journal entry could not be deleted', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftJournalRepository(db).create(
      bodyMarkdown: 'first light',
      entryDate: DateTime(2026, 8, 20),
      title: 'Morning',
    );
    await _openJournal(tester, db);
    await tester.tap(find.widgetWithText(ListTile, 'Morning'));
    await tester.pumpAndSettle();

    await refuseDeletes(db, 'journal_entries');
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text(deleteFailedMessage), findsOneWidget);
    expect(await DriftJournalRepository(db).getAll(), hasLength(1));
  });
}
