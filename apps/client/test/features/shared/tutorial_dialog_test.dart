import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/app/locale_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/shared/tutorial_dialog.dart';
import 'package:alveo/l10n/app_localizations.dart';

Future<ProviderContainer> _open(WidgetTester tester) async {
  final db = AppDatabase.forTesting();
  addTearDown(db.close);
  final container = ProviderContainer(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showTutorial(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('pages forward and back through the steps', (tester) async {
    await _open(tester);

    expect(find.text('Welcome to Alveo'), findsOneWidget);
    expect(find.text('Back'), findsNothing); // first page

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Daily check-in'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Alveo'), findsOneWidget);
  });

  testWidgets('the last step closes the dialog with Done', (tester) async {
    await _open(tester);

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Next'), findsNothing);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Alveo'), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Skip closes the dialog immediately', (tester) async {
    await _open(tester);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('first slide shows both support links', (tester) async {
    await _open(tester);

    expect(find.byKey(const ValueKey('support-cafecito')), findsOneWidget);
    expect(find.byKey(const ValueKey('support-patreon')), findsOneWidget);
  });

  testWidgets('first slide switches the app language', (tester) async {
    final container = await _open(tester);

    await tester.ensureVisible(find.text('Spanish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();

    expect(container.read(localeControllerProvider), const Locale('es'));
  });
}
