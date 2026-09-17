import 'package:alveo/app/platform.dart';
import 'package:alveo/app/theme_controller.dart';
import 'package:alveo/app/ui.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/shared/support_actions.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ProviderContainer> pumpSettings(
  WidgetTester tester, {
  bool web = false,
  ThemeMode mode = ThemeMode.light,
}) async {
  // Tall enough that the whole ListView builds at once.
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final db = AppDatabase.forTesting();
  addTearDown(db.close);
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      isWebProvider.overrideWithValue(web),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const AlveoApp()),
  );
  await tester.pumpAndSettle();
  await container.read(themeControllerProvider.notifier).setMode(mode);
  await tester.tap(find.byIcon(Icons.settings_outlined));
  await tester.pumpAndSettle();
  return container;
}

List<String> _labels(WidgetTester tester) => tester
    .widgetList<SectionLabel>(find.byType(SectionLabel))
    .map((l) => l.text.toUpperCase())
    .toList();

double _top(WidgetTester tester, Finder f) => tester.getTopLeft(f).dy;

void main() {
  testWidgets('opens each section in the standard order (native)', (
    tester,
  ) async {
    await pumpSettings(tester);
    expect(_labels(tester), [
      'APPEARANCE',
      'PROFILE',
      'LANGUAGE',
      'SECURITY',
      'OBSIDIAN',
      'YOUR DATA',
      'SUPPORT',
      'ABOUT',
    ]);
  });

  testWidgets('omits the desktop-only Obsidian section on the web', (
    tester,
  ) async {
    await pumpSettings(tester, web: true);
    expect(_labels(tester), [
      'APPEARANCE',
      'PROFILE',
      'LANGUAGE',
      'SECURITY',
      'YOUR DATA',
      'SUPPORT',
      'ABOUT',
    ]);
  });

  testWidgets('keeps sections flat and every row against the gutter', (
    tester,
  ) async {
    await pumpSettings(tester);
    expect(find.byType(SupportProjectsCard), findsOneWidget);
    final tiles = tester.widgetList<ListTile>(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(ListTile),
      ),
    );
    expect(tiles, isNotEmpty);
    for (final tile in tiles) {
      expect(tile.contentPadding, EdgeInsets.zero);
    }
  });

  testWidgets('your data: backup notice first, delete-all last', (
    tester,
  ) async {
    await pumpSettings(tester);
    final label = find.text('YOUR DATA');
    final notice = find.textContaining("Your data isn't stored");
    final export = find.text('Export backup');
    final erase = find.text('Delete all my data');
    final support = find.text('SUPPORT');
    expect(_top(tester, label), lessThan(_top(tester, notice)));
    expect(_top(tester, notice), lessThan(_top(tester, export)));
    expect(_top(tester, export), lessThan(_top(tester, erase)));
    expect(_top(tester, erase), lessThan(_top(tester, support)));
  });

  testWidgets(
    'about prints the disclaimer in full and ends with the tutorial',
    (tester) async {
      await pumpSettings(tester);
      final body = find.textContaining(
        'it is not a substitute for professional',
      );
      expect(body, findsOneWidget);
      expect(
        find.ancestor(of: body, matching: find.byType(ListTile)),
        findsNothing,
      );
      expect(
        _top(tester, find.text('ABOUT')),
        lessThan(_top(tester, find.text('Tutorial'))),
      );
    },
  );

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('settings meets accessibility guidelines (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSettings(tester, mode: mode);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }
}
