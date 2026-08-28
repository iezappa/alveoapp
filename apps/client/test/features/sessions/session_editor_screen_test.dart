import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/features/sessions/session_editor_screen.dart';
import 'package:alveo/main.dart';

Finder _editorField() => find.descendant(
  of: find.byType(SessionEditorScreen),
  matching: find.byType(TextField),
);

Future<void> _openSessions(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Sessions')); // navigation rail / bar destination
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('creates a session with an agenda', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openSessions(tester, db);
    expect(find.text('No sessions yet'), findsOneWidget);

    await tester.tap(find.byTooltip('New session')); // "+" in the list pane
    await tester.pumpAndSettle();

    // The Agenda tab is selected first.
    await tester.enterText(_editorField().first, '- talk about boundaries');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final sessions = await SessionRepository(db).getAll();
    expect(sessions, hasLength(1));
    expect(sessions.single.agendaMarkdown, contains('boundaries'));
  });

  testWidgets('opens an existing session and updates its agenda', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    final id = await SessionRepository(db)
        .create(scheduledFor: DateTime(2026, 9, 1, 10), agendaMarkdown: 'prep');

    await _openSessions(tester, db);

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await tester.enterText(_editorField().first, 'boundaries, sleep');
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final session = await SessionRepository(db).getById(id);
    expect(session!.agendaMarkdown, 'boundaries, sleep');
  });

  testWidgets('inserts a pre-session summary into the agenda', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openSessions(tester, db);
    await tester.tap(find.byTooltip('New session'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pre-session summary'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Since the last session'),
      findsWidgets,
    );

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final saved = (await SessionRepository(db).getAll()).single;
    expect(saved.agendaMarkdown, contains('Since the last session'));
  });
}
