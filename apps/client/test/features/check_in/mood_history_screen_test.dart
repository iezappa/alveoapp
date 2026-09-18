import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

void main() {
  testWidgets('history lists check-ins and opens one for editing', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await DriftMoodRepository(
      db,
    ).add(mood: 2, occurredAt: DateTime(2026, 8, 20, 9), note: 'rough morning');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Mood history'));
    await tester.pumpAndSettle();
    expect(find.textContaining('rough morning'), findsOneWidget);

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Edit check-in'), findsOneWidget);

    await tester.tap(find.byKey(const Key('mood-5')));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect((await DriftMoodRepository(db).getById(id))!.mood, 5);
  });

  // A refused delete used to vanish: the check-in stayed with nothing on
  // screen to say so.
  testWidgets('says so when the check-in could not be deleted', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftMoodRepository(
      db,
    ).add(mood: 2, occurredAt: DateTime(2026, 8, 20, 9), note: 'rough morning');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mood history'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await refuseDeletes(db, 'mood_entries');
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text(deleteFailedMessage), findsOneWidget);
    expect(find.text('Edit check-in'), findsOneWidget);
    expect(await DriftMoodRepository(db).getAll(), hasLength(1));
  });
}
