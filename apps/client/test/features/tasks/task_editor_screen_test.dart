import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/tables.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/main.dart';

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

    await tester.tap(find.text('New task')); // FAB label
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Practice grounding');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final tasks = await TaskRepository(db).getAll();
    expect(tasks, hasLength(1));
    expect(tasks.single.title, 'Practice grounding');
    expect(tasks.single.status, TaskStatus.pending);
  });

  testWidgets('edits a task and marks it done', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await TaskRepository(db).create(title: 'Draft task');

    await _openTasks(tester, db);

    await tester.tap(find.text('Draft task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Refined task');
    await tester.tap(find.text('Done')); // status chip
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final task = await TaskRepository(db).getById(id);
    expect(task!.title, 'Refined task');
    expect(task.status, TaskStatus.done);
    expect(task.completedAt, isNotNull);
  });
}
