import 'package:alveo/app/platform.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _caveat =
    'On the web version, the PIN deters casual access but does not protect '
    'against someone with access to this browser or device.';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting());
  tearDown(() => db.close());

  Future<void> openSettings(WidgetTester tester, {required bool web}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          isWebProvider.overrideWithValue(web),
        ],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Set a PIN'), 200);
  }

  testWidgets('on the web, the PIN section says what the PIN is worth', (
    tester,
  ) async {
    await openSettings(tester, web: true);

    expect(find.text(_caveat), findsOneWidget);
  });

  testWidgets('on the web, setting a PIN says it too', (tester) async {
    await openSettings(tester, web: true);

    await tester.tap(find.text('Set a PIN'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(_caveat),
      ),
      findsOneWidget,
    );
  });

  testWidgets('native builds do not carry the web caveat', (tester) async {
    await openSettings(tester, web: false);

    expect(find.text(_caveat), findsNothing);
  });
}
