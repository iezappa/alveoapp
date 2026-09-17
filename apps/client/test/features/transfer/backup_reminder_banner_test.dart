import 'package:alveo/app/clock.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/transfer/backup_history.dart';
import 'package:alveo/features/export/file_saver_provider.dart';
import 'package:alveo/features/transfer/backup_reminder_banner.dart';
import 'package:alveo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  var saves = 0;

  setUp(() {
    db = AppDatabase.forTesting();
    now = DateTime(2026, 9, 16, 12);
    saves = 0;
  });
  tearDown(() => db.close());

  Future<ProviderContainer> pump(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
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
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(body: BackupReminderBanner()),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('stays quiet when nothing has been written', (tester) async {
    await pump(tester);

    expect(find.byType(MaterialBanner), findsNothing);
  });

  testWidgets('reminds when data was never exported', (tester) async {
    await DriftTaskRepository(db).create(title: 'Breathe');
    await pump(tester);

    expect(find.text("You haven't backed up your data yet."), findsOneWidget);
  });

  testWidgets('reminds with the age once the last export is old', (
    tester,
  ) async {
    await DriftTaskRepository(db).create(title: 'Breathe');
    await BackupHistory(db)
        .recordExport(now.subtract(const Duration(days: 40)));
    await pump(tester);

    expect(find.text('Your last backup was 40 days ago.'), findsOneWidget);
  });

  testWidgets('"Not now" snoozes it and remembers when', (tester) async {
    await DriftTaskRepository(db).create(title: 'Breathe');
    await pump(tester);

    await tester.tap(find.text('Not now'));
    await settle(tester);

    expect(find.byType(MaterialBanner), findsNothing);
    expect(await BackupHistory(db).reminderDismissedAt(), now);
  });

  testWidgets('exporting records the date and hides it', (tester) async {
    await DriftTaskRepository(db).create(title: 'Breathe');
    await pump(tester);

    await tester.tap(find.text('Export'));
    await settle(tester);
    await tester.tap(find.text('Continue')); // the unencrypted-file warning
    await settle(tester);

    expect(saves, 1);
    expect(await BackupHistory(db).lastExportAt(), now);
    expect(find.byType(MaterialBanner), findsNothing);
  });
}
