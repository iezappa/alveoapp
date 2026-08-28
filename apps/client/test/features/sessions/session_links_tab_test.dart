import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/link_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/main.dart';

void main() {
  testWidgets('links a task to a session from the Links tab', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await TaskRepository(db).create(title: 'Practice grounding');
    await SessionRepository(db)
        .create(scheduledFor: DateTime(2026, 9, 1, 10), agendaMarkdown: 'prep');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sessions')); // navigation rail / bar
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Links'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing linked yet'), findsOneWidget);

    await tester.tap(find.text('Link an item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Practice grounding'));
    await tester.pumpAndSettle();

    expect(find.text('Practice grounding'), findsOneWidget);

    final sessionId = (await SessionRepository(db).getAll()).single.id;
    expect(await LinkRepository(db).linkedItems(sessionId), hasLength(1));
  });
}
