import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/domain/emotions/emotion_input.dart';
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
  testWidgets('creates a journal entry via the "+" section picker', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openJournal(tester, db);

    await tester.tap(find.byTooltip('New entry'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(ListTile, 'One-liners'),
    ); // section menu
    await tester.pumpAndSettle();

    await tester.enterText(
      _editorField().last, // title field first, Markdown body last
      '# Session 1\n\nTalked about boundaries.',
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final entries = await DriftJournalRepository(db).getAll();
    expect(entries, hasLength(1));
    expect(entries.single.bodyMarkdown, contains('boundaries'));
  });

  testWidgets('opens an existing entry from its tile and updates it', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await DriftJournalRepository(db).create(
      bodyMarkdown: 'first draft',
      entryDate: DateTime(2026, 8, 20),
      title: 'Draft',
    );

    await _openJournal(tester, db);

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();

    expect(find.text('first draft'), findsWidgets);

    await tester.enterText(_editorField().last, 'second draft');
    await tester.pump();
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final entry = await DriftJournalRepository(db).getById(id);
    expect(entry!.bodyMarkdown, 'second draft');
  });

  testWidgets('keeps the typed text when the entry could not be saved', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await _openJournal(tester, db);

    await tester.tap(find.byTooltip('New entry'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'One-liners'));
    await tester.pumpAndSettle();
    await tester.enterText(_editorField().last, 'words I cannot lose');
    await tester.pump();

    await refuseWrites(db, 'journal_entries');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(find.text(saveFailedMessage), findsOneWidget);
    // Still in the editor, with the text, so it can be retried or copied.
    expect(find.byType(JournalEditorScreen), findsOneWidget);
    expect(find.text('words I cannot lose'), findsWidgets);
    final save = tester.widget<IconButton>(
      find
          .ancestor(
            of: find.byTooltip('Save'),
            matching: find.byType(IconButton),
          )
          .first,
    );
    expect(save.onPressed, isNotNull);
  });

  // Editing an entry wrote the body, then the emotions, as two separate
  // writes. When the second was refused, the new body stayed saved even
  // though the editor said the save had failed.
  testWidgets('an edited entry is saved whole or not at all', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await DriftJournalRepository(db).create(
      bodyMarkdown: 'first draft',
      entryDate: DateTime(2026, 8, 20),
      title: 'Draft',
      // The refusal below fires per row, so there has to be one to replace.
      emotions: const [EmotionInput(emotionKey: 'joy', intensity: 3)],
    );
    await _openJournal(tester, db);
    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();
    await tester.enterText(_editorField().last, 'second draft');
    await tester.pump();

    await db.customStatement(
      'CREATE TRIGGER refuse_emotions BEFORE DELETE ON journal_entry_emotions '
      "BEGIN SELECT RAISE(ABORT, 'refused'); END",
    );
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(
      (await DriftJournalRepository(db).getById(id))!.bodyMarkdown,
      'first draft',
    );
    expect(find.text(saveFailedMessage), findsOneWidget);
    expect(find.text('second draft'), findsWidgets);
  });
}
