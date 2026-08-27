import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/local/tables.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/data/repositories/task_repository.dart';
import 'package:terapia/main.dart';

Future<void> _openTasks(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const TerapiaApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.more_vert));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Tasks'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('open tasks sort before finished ones', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final repo = TaskRepository(db);
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
    final repo = TaskRepository(db);
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
}
