import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/data/repositories/mood_repository.dart';
import 'package:terapia/main.dart';

Future<void> _pumpApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const TerapiaApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Timeline')); // leave the dashboard start screen
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists a saved mood entry with its note', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await MoodRepository(db)
        .add(mood: 4, occurredAt: DateTime(2026, 8, 20, 9), note: 'ok day');

    await _pumpApp(tester, db);

    expect(find.text('Mood 4/5'), findsOneWidget);
    expect(find.textContaining('ok day'), findsOneWidget);
  });

  testWidgets('shows the empty state when nothing is logged', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await _pumpApp(tester, db);

    expect(find.text('Nothing logged yet'), findsOneWidget);
  });
}
