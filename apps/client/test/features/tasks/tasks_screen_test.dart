import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/tables.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

Future<void> _openTasks(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Tasks')); // navigation rail / bar destination
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('open tasks sort before finished ones', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final repo = DriftTaskRepository(db);
    final doneId = await repo.create(title: 'Old task');
    await repo.setStatus(doneId, TaskStatus.done);
    await repo.create(title: 'Breathe daily');

    await _openTasks(tester, db);

    expect(
      tester.getTopLeft(find.text('Breathe daily')).dy,
      lessThan(tester.getTopLeft(find.text('Old task')).dy),
    );
  });

  testWidgets('the checkbox marks a task done', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final repo = DriftTaskRepository(db);
    await repo.create(title: 'Breathe daily');

    await _openTasks(tester, db);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Breathe daily'),
        matching: find.byType(Checkbox),
      ),
    );
    await tester.pumpAndSettle();

    final task = (await repo.getAll()).single;
    expect(task.status, TaskStatus.done);
    expect(task.completedAt, isNotNull);
  });

  testWidgets('shows an empty state', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openTasks(tester, db);

    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('wide layout previews the selected task in place', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftTaskRepository(db).create(
      title: 'Practice grounding',
      descriptionMarkdown: 'five senses exercise',
    );

    await _openTasks(tester, db);

    expect(find.text('Pick a record to see it here'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Practice grounding'));
    await tester.pumpAndSettle();

    expect(find.text('five senses exercise'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });

  // A refused delete used to vanish: the task stayed with nothing on screen
  // to say so, and the user walked away believing it was gone.
  testWidgets('says so when the task could not be deleted', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftTaskRepository(db).create(title: 'Breathe daily');
    await _openTasks(tester, db);
    await tester.tap(find.widgetWithText(ListTile, 'Breathe daily'));
    await tester.pumpAndSettle();

    await refuseDeletes(db, 'tasks');
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text(deleteFailedMessage), findsOneWidget);
    expect(await DriftTaskRepository(db).getAll(), hasLength(1));
  });
}
