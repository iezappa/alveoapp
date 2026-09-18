import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/medication_repository.dart';
import 'package:alveo/features/medication/medication_editor_screen.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

Future<void> _openMeds(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.text('Medications'),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await _centre(tester, find.text('Medications'));
  await tester.tap(find.text('Medications')); // dashboard quick link
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('adds a medication then logs a dose', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openMeds(tester, db);
    expect(find.text('No medications tracked'), findsOneWidget);

    await tester.tap(find.text('New medication')); // FAB
    await tester.pumpAndSettle();
    await tester.enterText(
      find
          .descendant(
            of: find.byType(MedicationEditorScreen),
            matching: find.byType(TextField),
          )
          .first,
      'Melatonin',
    );
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Melatonin'), findsOneWidget);

    await tester.tap(find.byTooltip('Log a dose'));
    await tester.pumpAndSettle();

    final doses = await DriftMedicationRepository(db).dosesOn(
      (await DriftMedicationRepository(db).getAll()).single.id,
      DateTime.now(),
    );
    expect(doses, hasLength(1));
    expect(find.text('1 dose today'), findsOneWidget);
  });

  testWidgets('says so when the medication could not be saved', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await _openMeds(tester, db);
    await tester.tap(find.text('New medication'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find
          .descendant(
            of: find.byType(MedicationEditorScreen),
            matching: find.byType(TextField),
          )
          .first,
      'Melatonin',
    );

    await refuseWrites(db, 'medications');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(find.text(saveFailedMessage), findsOneWidget);
    expect(find.byType(MedicationEditorScreen), findsOneWidget);
  });

  testWidgets('says so when the dose could not be logged', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftMedicationRepository(db).create(name: 'Melatonin');
    await _openMeds(tester, db);

    await refuseWrites(db, 'medication_logs');
    await tester.tap(find.byTooltip('Log a dose'));
    await tester.pumpAndSettle();

    expect(find.text(saveFailedMessage), findsOneWidget);
  });

  testWidgets('says so when the medication could not be deleted', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftMedicationRepository(db).create(name: 'Melatonin');
    await _openMeds(tester, db);
    await tester.tap(find.text('Melatonin'));
    await tester.pumpAndSettle();

    await refuseDeletes(db, 'medications');
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text(deleteFailedMessage), findsOneWidget);
    expect(find.byType(MedicationEditorScreen), findsOneWidget);
    expect(await DriftMedicationRepository(db).getAll(), hasLength(1));
  });
}

/// Scrolls [finder] to the middle of the viewport, clear of the bottom bar
/// that would otherwise swallow the tap.
Future<void> _centre(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}
