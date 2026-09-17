import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/features/all_records/all_records_screen.dart';
import 'package:alveo/l10n/app_localizations.dart';

Future<void> _pump(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AllRecordsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows an empty state when nothing has been written', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pump(tester, db);

    expect(find.text('Nothing written yet'), findsOneWidget);
  });

  testWidgets('lists every text, newest first', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await DriftJournalRepository(db).create(
      bodyMarkdown: 'A quiet morning walk.',
      entryDate: DateTime(2026, 2, 10),
      title: 'Morning',
    );
    await DriftSessionRepository(db).create(
      scheduledFor: DateTime(2026, 3, 5),
      notesMarkdown: 'Talked about sleep.',
    );

    await _pump(tester, db);

    expect(find.text('A quiet morning walk.'), findsOneWidget);
    expect(find.text('Talked about sleep.'), findsOneWidget);
    expect(find.text('Morning'), findsOneWidget);

    // The session (March) is rendered above the journal entry (February).
    final sessionY = tester.getCenter(find.text('Talked about sleep.')).dy;
    final journalY = tester.getCenter(find.text('A quiet morning walk.')).dy;
    expect(sessionY, lessThan(journalY));
  });

  testWidgets('omits records that carry no text', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await DriftSessionRepository(db).create(scheduledFor: DateTime(2026, 1, 1));

    await _pump(tester, db);

    expect(find.text('Nothing written yet'), findsOneWidget);
  });
}
