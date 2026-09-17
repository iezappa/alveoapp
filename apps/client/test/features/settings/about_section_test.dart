import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/legal/legal_document_screen.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _openSettings(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final db = AppDatabase.forTesting();
  addTearDown(db.close);
  final container = ProviderContainer(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const AlveoApp()),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.settings_outlined));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('About lists privacy, terms, developer contact and licenses', (
    tester,
  ) async {
    await _openSettings(tester);
    expect(find.text('Privacy policy'), findsOneWidget);
    expect(find.text('Terms of use'), findsOneWidget);
    expect(find.text('Developer and contact'), findsOneWidget);
    expect(find.textContaining(developerName), findsOneWidget);
    expect(find.text('Licenses'), findsOneWidget);
  });

  testWidgets('the privacy row opens the bundled policy', (tester) async {
    await _openSettings(tester);
    await tester.tap(find.text('Privacy policy'));
    await tester.pumpAndSettle();
    expect(find.byType(LegalDocumentScreen), findsOneWidget);
    expect(find.text('Alveo privacy policy'), findsOneWidget);
  });

  testWidgets('the terms row opens the bundled terms', (tester) async {
    await _openSettings(tester);
    await tester.tap(find.text('Terms of use'));
    await tester.pumpAndSettle();
    expect(find.text('Alveo terms of use'), findsOneWidget);
  });

  testWidgets('the licenses row opens the license page', (tester) async {
    await _openSettings(tester);
    await tester.tap(find.text('Licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });
}
