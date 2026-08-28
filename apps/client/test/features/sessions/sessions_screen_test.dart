import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/main.dart';

void main() {
  testWidgets('wide layout shows the list and a preview side by side', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await SessionRepository(db).create(
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
}
