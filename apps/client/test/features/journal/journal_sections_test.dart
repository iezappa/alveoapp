import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/data/repositories/journal_repository.dart';
import 'package:terapia/domain/journal/journal_section.dart';
import 'package:terapia/main.dart';

Future<void> _openJournal(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const TerapiaApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Journal')); // navigation destination
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the journal home lists every section', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openJournal(tester, db);

    expect(find.text('One-liners'), findsOneWidget);
    expect(find.text('Creative'), findsOneWidget);
    expect(find.text('Win log'), findsOneWidget);
    expect(find.text('Therapy'), findsOneWidget);
  });

  testWidgets('an entry added inside a section is filed there', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openJournal(tester, db);

    await tester.tap(find.text('Creative'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add)); // section FAB
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'a poem idea');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final creative = await JournalRepository(db)
        .getBySection(JournalSection.creative);
    expect(creative, hasLength(1));
    expect(creative.single.bodyMarkdown, 'a poem idea');
  });
}
