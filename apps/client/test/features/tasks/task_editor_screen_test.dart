import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/tables.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/features/tasks/task_editor_screen.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

Finder _inEditor(Finder matching) =>
    find.descendant(of: find.byType(TaskEditorScreen), matching: matching);

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
  testWidgets('creates a task from the tasks screen', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openTasks(tester, db);

    await tester.tap(find.byTooltip('New task')); // "+" in the list pane
    await tester.pumpAndSettle();

    await tester.enterText(
      _inEditor(find.byType(TextField)).first,
      'Practice grounding',
    );
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final tasks = await DriftTaskRepository(db).getAll();
    expect(tasks, hasLength(1));
    expect(tasks.single.title, 'Practice grounding');
    expect(tasks.single.status, TaskStatus.pending);
  });

  testWidgets('edits a task and marks it done', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await DriftTaskRepository(db).create(title: 'Draft task');

    await _openTasks(tester, db);

    await tester.tap(find.text('Draft task'));
    await tester.pumpAndSettle();

    await tester.enterText(
      _inEditor(find.byType(TextField)).first,
      'Refined task',
    );
    await tester.tap(_inEditor(find.text('Done'))); // status chip in the editor
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final task = await DriftTaskRepository(db).getById(id);
    expect(task!.title, 'Refined task');
    expect(task.status, TaskStatus.done);
    expect(task.completedAt, isNotNull);
  });

  testWidgets('says so when the task could not be saved', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await _openTasks(tester, db);
    await tester.tap(find.byTooltip('New task'));
    await tester.pumpAndSettle();
    await tester.enterText(
      _inEditor(find.byType(TextField)).first,
      'Call the clinic',
    );

    await refuseWrites(db, 'tasks');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    expect(find.text(saveFailedMessage), findsOneWidget);
    expect(find.text('Call the clinic'), findsWidgets);
  });
}
