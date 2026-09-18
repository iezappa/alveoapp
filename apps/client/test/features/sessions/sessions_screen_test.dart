import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/features/sessions/session_editor_screen.dart';
import 'package:alveo/main.dart';

import '../../helpers/refuse_writes.dart';

Future<void> _openSessionsWide(WidgetTester tester, AppDatabase db) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const AlveoApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Sessions'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('wide layout shows the list and a preview side by side', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftSessionRepository(db).create(
      scheduledFor: DateTime(2026, 9, 1, 10),
      agendaMarkdown: 'talk about boundaries',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sessions'));
    await tester.pumpAndSettle();

    // Detail pane starts empty.
    expect(find.text('Pick a record to see it here'), findsOneWidget);

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // The preview appears in place — no navigation.
    expect(find.text('talk about boundaries'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets('wide layout adds a session inline in the pane', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _openSessionsWide(tester, db);

    await tester.tap(find.byTooltip('New session'));
    await tester.pumpAndSettle();

    // The editor is embedded, not pushed: the shell nav rail is still there.
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'New session'), findsOneWidget);

    await tester.enterText(
      find
          .descendant(
            of: find.byType(SessionEditorScreen),
            matching: find.byType(TextField),
          )
          .first,
      '- inline agenda',
    );
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    final sessions = await DriftSessionRepository(db).getAll();
    expect(sessions.single.agendaMarkdown, contains('inline agenda'));
    // Back to the empty detail pane.
    expect(find.text('Pick a record to see it here'), findsOneWidget);
  });

  // A refused delete used to vanish: the session stayed with nothing on screen
  // to say so, and the user walked away believing it was gone.
  testWidgets('says so when the session could not be deleted', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await DriftSessionRepository(db).create(
      scheduledFor: DateTime(2026, 9, 1, 10),
      agendaMarkdown: 'talk about boundaries',
    );
    await _openSessionsWide(tester, db);
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await refuseDeletes(db, 'sessions');
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text(deleteFailedMessage), findsOneWidget);
    expect(await DriftSessionRepository(db).getAll(), hasLength(1));
  });
}
