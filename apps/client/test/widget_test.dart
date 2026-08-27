import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/main.dart';

void main() {
  testWidgets('language toggle in settings switches UI copy to Spanish',
      (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const TerapiaApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Timeline is the start screen.
    expect(find.text('Timeline'), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();

    expect(find.text('Idioma'), findsOneWidget);
  });
}
