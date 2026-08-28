import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/features/journal/journal_editor_screen.dart';
import 'package:alveo/main.dart';

Finder _editorField() => find.descendant(
  of: find.byType(JournalEditorScreen),
  matching: find.byType(TextField),
);

Future<void> _openTimeline(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Timeline')); // leave the dashboard start screen
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('creates a journal entry from the timeline "+" menu', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openTimeline(tester, db);

    await tester.tap(find.byTooltip('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New entry')); // create menu
    await tester.pumpAndSettle();

    await tester.enterText(
      _editorField().last, // title field first, Markdown body last
      '# Session 1\n\nTalked about boundaries.',
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    // Back on the timeline, now showing the new entry.
    expect(find.text('Untitled entry'), findsOneWidget);

    final entries = await JournalRepository(db).getAll();
    expect(entries, hasLength(1));
    expect(entries.single.bodyMarkdown, contains('boundaries'));
  });

  testWidgets('opens an existing entry from its timeline tile and updates it', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await JournalRepository(db).create(
      bodyMarkdown: 'first draft',
      entryDate: DateTime(2026, 8, 20),
      title: 'Draft',
    );

    await _openTimeline(tester, db);

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();

    expect(find.text('first draft'), findsWidgets);

    await tester.enterText(_editorField().last, 'second draft');
    await tester.pump();
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final entry = await JournalRepository(db).getById(id);
    expect(entry!.bodyMarkdown, 'second draft');
  });
}
