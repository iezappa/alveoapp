import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/features/check_in/plutchik_wheel.dart';
import 'package:alveo/main.dart';

void main() {
  testWidgets('a check-in persists the mood score and selected emotions', (
    tester,
  ) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // The check-in opens from the dashboard card.
    await tester.tap(find.text('Daily check-in'));
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

    // Back on the dashboard.
    expect(
      find.text("Take a deep breath. You're safe here."),
      findsOneWidget,
    );

    final repo = MoodRepository(db);
    final entries = await repo.getAll();
    expect(entries, hasLength(1));
    expect(entries.single.mood, 4);

    final emotions = await repo.emotionsFor(entries.single.id);
    expect(emotions.map((e) => e.emotionKey), ['joy']);
    expect(emotions.single.intensity, 3); // default intensity
  });
}
