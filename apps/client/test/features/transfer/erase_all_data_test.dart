import 'package:alveo/app/app_restart.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/features/export/file_saver_provider.dart';
import 'package:alveo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late int restarts;
  late int saves;

  setUp(() {
    db = AppDatabase.forTesting();
    restarts = 0;
    saves = 0;
  });
  tearDown(() => db.close());

  Future<void> openSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          restartAppProvider.overrideWithValue(() async => restarts++),
          textFileSaverProvider.overrideWithValue(({
            required suggestedName,
            required contents,
            required typeLabel,
            required extensions,
          }) async {
            saves++;
            return suggestedName;
          }),
        ],
        child: const AlveoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('the data section opens with the backup notice', (tester) async {
    await openSettings(tester);
    await tester.scrollUntilVisible(find.text('Export backup'), 200);

    final notice = find.text(
      "Your data isn't stored on our servers. Export regularly and keep the "
      'file off this device.',
    );
    expect(notice, findsOneWidget);
    expect(
      tester.getTopLeft(notice).dy,
      lessThan(tester.getTopLeft(find.text('Export backup')).dy),
    );
  });

  testWidgets('"Delete all my data" closes the data section', (tester) async {
    await openSettings(tester);
    await tester.scrollUntilVisible(find.text('Delete all my data'), 200);

    expect(
      tester.getTopLeft(find.text('Delete all my data')).dy,
      greaterThan(tester.getTopLeft(find.text('Import backup')).dy),
    );
  });

  testWidgets('deletes nothing until the word is typed', (tester) async {
    await TaskRepository(db).create(title: 'Breathe');
    await openSettings(tester);
    await tester.scrollUntilVisible(find.text('Delete all my data'), 200);
    await tester.tap(find.text('Delete all my data'));
    await tester.pumpAndSettle();

    final erase = find.widgetWithText(FilledButton, 'Delete everything');
    expect(tester.widget<FilledButton>(erase).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'delete');
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(erase).onPressed, isNotNull);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await TaskRepository(db).getAll(), hasLength(1));
    expect(restarts, 0);
  });

  testWidgets('offers to export first', (tester) async {
    await openSettings(tester);
    await tester.scrollUntilVisible(find.text('Delete all my data'), 200);
    await tester.tap(find.text('Delete all my data'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Export first'));
    await settle(tester);

    expect(saves, 1);
  });

  testWidgets('once confirmed, wipes everything and restarts', (tester) async {
    await TaskRepository(db).create(title: 'Breathe');
    await SettingsRepository(db).set('profile.name', 'Ana');
    await openSettings(tester);
    await tester.scrollUntilVisible(find.text('Delete all my data'), 200);
    await tester.tap(find.text('Delete all my data'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'DELETE');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete everything'));
    await settle(tester);

    expect(await TaskRepository(db).getAll(), isEmpty);
    expect(await SettingsRepository(db).get('profile.name'), isNull);
    expect(restarts, 1);
  });
}
