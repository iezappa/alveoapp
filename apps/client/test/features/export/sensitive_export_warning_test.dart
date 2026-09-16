import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/export/file_saver_provider.dart';
import 'package:alveo/features/export/sensitive_export_warning.dart';
import 'package:alveo/features/transfer/backup_actions.dart';
import 'package:alveo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _warning =
    'This file contains your therapy notes unencrypted. Store it somewhere '
    'private.';

void main() {
  late AppDatabase db;
  late int saves;

  setUp(() {
    db = AppDatabase.forTesting();
    saves = 0;
  });
  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
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
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => runExportBackup(context, ref),
                  child: const Text('export'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('warns before a backup is written', (tester) async {
    await pump(tester);

    await tester.tap(find.text('export'));
    await settle(tester);

    expect(find.text(_warning), findsOneWidget);
    expect(saves, 0);
  });

  testWidgets('writes nothing when the warning is cancelled', (tester) async {
    await pump(tester);

    await tester.tap(find.text('export'));
    await settle(tester);
    await tester.tap(find.text('Cancel'));
    await settle(tester);

    expect(saves, 0);
  });

  testWidgets('writes the file once the warning is accepted', (tester) async {
    await pump(tester);

    await tester.tap(find.text('export'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(saves, 1);
  });

  testWidgets('asks again next time unless muted for the session', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('export'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);

    await tester.tap(find.text('export'));
    await settle(tester);
    expect(find.text(_warning), findsOneWidget);

    await tester.tap(find.text("Don't show again this session"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await settle(tester);

    await tester.tap(find.text('export'));
    await settle(tester);
    expect(find.text(_warning), findsNothing);
    expect(saves, 3);
  });

  test('muting lasts only as long as the app runs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(sensitiveExportWarningMutedProvider), isFalse);
    container.read(sensitiveExportWarningMutedProvider.notifier).mute();
    expect(container.read(sensitiveExportWarningMutedProvider), isTrue);

    final nextRun = ProviderContainer();
    addTearDown(nextRun.dispose);
    expect(nextRun.read(sensitiveExportWarningMutedProvider), isFalse);
  });
}
