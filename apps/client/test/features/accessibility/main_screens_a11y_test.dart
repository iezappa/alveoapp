import 'package:alveo/app/theme_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The five tabs of the bottom bar, by the icon that opens each.
const _tabs = <String, IconData>{
  'home': Icons.home_outlined,
  'journal': Icons.book_outlined,
  'sessions': Icons.psychology_outlined,
  'tasks': Icons.checklist_outlined,
  'tools': Icons.lightbulb_outline,
};

void main() {
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final tab in _tabs.entries) {
      testWidgets('${tab.key} meets accessibility guidelines (${mode.name})', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(420, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final handle = tester.ensureSemantics();

        final db = AppDatabase.forTesting();
        addTearDown(db.close);
        final container = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const AlveoApp(),
          ),
        );
        await tester.pumpAndSettle();
        await container.read(themeControllerProvider.notifier).setMode(mode);
        // Home is already open, so its bar shows the selected icon instead.
        if (tab.key != 'home') {
          await tester.tap(find.byIcon(tab.value).first);
          await tester.pumpAndSettle();
        }

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }
  }
}
