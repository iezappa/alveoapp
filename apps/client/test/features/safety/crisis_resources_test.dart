import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/safety/crisis_resources.dart';
import 'package:alveo/features/shared/support_actions.dart' show UrlOpener;
import 'package:alveo/l10n/app_localizations.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCard(
    WidgetTester tester, {
    Locale locale = const Locale('es'),
    UrlOpener? open,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CrisisResourcesCard(open: open ?? (_) async => true),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists the Argentine crisis lines and emergencies', (
    tester,
  ) async {
    await pumpCard(tester);

    expect(find.textContaining('Línea 135'), findsOneWidget);
    expect(find.textContaining('gratuita desde CABA y GBA'), findsOneWidget);
    expect(find.textContaining('(011) 5275-1135'), findsOneWidget);
    expect(find.textContaining('desde todo el país'), findsOneWidget);
    expect(
      find.textContaining('Centro de Asistencia al Suicida'),
      findsWidgets,
    );
    expect(find.textContaining('911'), findsOneWidget);
  });

  testWidgets('does not list the unverified 0800 number', (tester) async {
    await pumpCard(tester);

    expect(find.textContaining('0800'), findsNothing);
    expect(
      crisisLines.map((line) => line.dial.toString()),
      isNot(contains(contains('0800'))),
    );
  });

  testWidgets('tapping a line dials it', (tester) async {
    final opened = <Uri>[];
    await pumpCard(
      tester,
      open: (uri) async {
        opened.add(uri);
        return true;
      },
    );

    await tester.tap(find.textContaining('Línea 135'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('(011) 5275-1135'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('911'));
    await tester.pumpAndSettle();

    expect(opened, [
      Uri.parse('tel:135'),
      Uri.parse('tel:+541152751135'),
      Uri.parse('tel:911'),
    ]);
  });

  testWidgets('says so when the device cannot place a call', (tester) async {
    await pumpCard(
      tester,
      locale: const Locale('en'),
      open: (_) async => false,
    );

    await tester.tap(find.textContaining('911'));
    await tester.pumpAndSettle();

    expect(find.textContaining("Couldn't start a call"), findsOneWidget);
  });

  group('in the app', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase.forTesting());
    tearDown(() => db.close());

    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const AlveoApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Settings shows them in the about section', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(CrisisResourcesCard), 300);

      expect(find.byType(CrisisResourcesCard), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(CrisisResourcesCard)).dy,
        greaterThan(tester.getTopLeft(find.text('ABOUT')).dy),
      );
    });

    testWidgets('the safety plan opens with them, above the plan', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.scrollUntilVisible(
        find.text('Safety plan'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await _centre(tester, find.text('Safety plan'));
      await tester.tap(find.text('Safety plan'));
      await tester.pumpAndSettle();

      expect(find.byType(CrisisResourcesCard), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(CrisisResourcesCard)).dy,
        lessThan(tester.getTopLeft(find.byType(TextField).first).dy),
      );
    });
  });
}

/// Scrolls [finder] to the middle of the viewport, clear of the bottom bar
/// that would otherwise swallow the tap.
Future<void> _centre(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}
