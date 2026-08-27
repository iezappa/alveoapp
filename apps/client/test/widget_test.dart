import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/providers.dart';
import 'package:terapia/main.dart';

void main() {
  testWidgets('language toggle switches UI copy to Spanish', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const TerapiaApp(),
      ),
    );
    await tester.pumpAndSettle();

    // No stored choice → resolves to English in the test environment.
    expect(find.text('Language'), findsOneWidget);

    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();

    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Language'), findsNothing);
  });
}
