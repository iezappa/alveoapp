import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/data/repositories/mood_repository.dart';
import 'package:terapia/features/check_in/plutchik_wheel.dart';
import 'package:terapia/main.dart';

void main() {
  testWidgets('a check-in persists the mood score and selected emotions', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const TerapiaApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Timeline')); // leave the dashboard start screen
    await tester.pumpAndSettle();

    await tester.tap(find.text('New check-in'));
    await tester.pumpAndSettle();
    expect(find.text('How are you feeling?'), findsOneWidget);

    // Overall mood -> 4.
    await tester.tap(find.byKey(const Key('mood-4')));
    await tester.pump();

    // Pick "joy": the wedge centred on north.
    await tester.ensureVisible(find.byType(PlutchikWheel));
    await tester.pumpAndSettle();
    final wheelRect = tester.getRect(find.byType(PlutchikWheel));
    await tester.tapAt(
      Offset(wheelRect.center.dx, wheelRect.center.dy - wheelRect.height * 0.3),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Returned to the timeline.
    expect(find.text('New check-in'), findsOneWidget); // back on the timeline

    final repo = MoodRepository(db);
    final entries = await repo.getAll();
    expect(entries, hasLength(1));
    expect(entries.single.mood, 4);

    final emotions = await repo.emotionsFor(entries.single.id);
    expect(emotions.map((e) => e.emotionKey), ['joy']);
    expect(emotions.single.intensity, 3); // default intensity
  });
}
