import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/data/repositories/journal_repository.dart';
import 'package:terapia/main.dart';

Future<void> _pumpApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const TerapiaApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Timeline')); // leave the dashboard start screen
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('creates a journal entry from the timeline action', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    await tester.tap(find.byIcon(Icons.note_add_outlined));
    await tester.pumpAndSettle();

    // Title field first, Markdown body field last.
    await tester.enterText(
      find.byType(TextField).last,
      '# Session 1\n\nTalked about boundaries.',
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(find.text('New check-in'), findsOneWidget); // back on the timeline

    final entries = await JournalRepository(db).getAll();
    expect(entries, hasLength(1));
    expect(entries.single.bodyMarkdown, contains('boundaries'));
  });

  testWidgets('opens an existing entry from its tile and updates it', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await JournalRepository(db).create(
      bodyMarkdown: 'first draft',
      entryDate: DateTime(2026, 8, 20),
      title: 'Draft',
    );

    await _pumpApp(tester, db);

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();

    expect(find.text('first draft'), findsWidgets); // in the field + preview

    await tester.enterText(find.byType(TextField).last, 'second draft');
    await tester.pump();
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final entry = await JournalRepository(db).getById(id);
    expect(entry!.bodyMarkdown, 'second draft');
  });
}
