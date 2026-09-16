import 'dart:io';

import 'package:alveo/app/app_restart.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/database_health.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/transfer/backup_service.dart';
import 'package:alveo/domain/transfer/import_report.dart';
import 'package:alveo/features/recovery/database_gate.dart';
import 'package:alveo/features/recovery/recovery_actions.dart';
import 'package:alveo/l10n/app_localizations.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late File file;
  late int restarts;
  late String? toOpen;
  late ProviderContainer container;

  // Recovery opens a second connection to the same file on purpose.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('alveo_recovery_');
    file = File('${dir.path}/alveo.sqlite')
      ..writeAsStringSync('not a database, and never was');
    restarts = 0;
    toOpen = null;
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(
          AppDatabase(NativeDatabase(file)),
        ),
        openDatabaseProvider.overrideWithValue(
          () => AppDatabase(NativeDatabase(file)),
        ),
        eraseLocalStoreProvider.overrideWithValue(() async {
          if (file.existsSync()) file.deleteSync();
        }),
        pickBackupSourceProvider.overrideWithValue(() async => toOpen),
        restartAppProvider.overrideWithValue(() async => restarts++),
      ],
    );
  });
  tearDown(() {
    container.dispose();
    dir.deleteSync(recursive: true);
  });

  Future<String> backupWithOneEntry() async {
    final source = AppDatabase.forTesting();
    addTearDown(source.close);
    await JournalRepository(source).create(
      title: 'Hoy',
      bodyMarkdown: 'querido',
      entryDate: DateTime(2026, 9, 1),
    );
    return BackupService(source).exportToJson();
  }

  group('DatabaseRecoveryActions', () {
    test('reset throws the broken store away and restarts the app', () async {
      await container.read(databaseRecoveryActionsProvider).reset();

      expect(file.existsSync(), isFalse);
      expect(restarts, 1);
    });

    test('import restores the backup into a fresh store', () async {
      toOpen = await backupWithOneEntry();

      final report = await container
          .read(databaseRecoveryActionsProvider)
          .importBackup();

      expect(report, isNotNull);
      expect(restarts, 1);
      final reopened = AppDatabase(NativeDatabase(file));
      addTearDown(reopened.close);
      expect(await probeDatabase(reopened), isA<DatabaseHealthy>());
      expect(
        await reopened.select(reopened.journalEntries).get(),
        hasLength(1),
      );
    });

    test('import touches nothing when the file is not a backup', () async {
      toOpen = 'querido diario';

      await expectLater(
        container.read(databaseRecoveryActionsProvider).importBackup(),
        throwsA(isA<ImportException>()),
      );
      expect(file.existsSync(), isTrue);
      expect(restarts, 0);
    });

    test('import touches nothing when the user backs out', () async {
      final report = await container
          .read(databaseRecoveryActionsProvider)
          .importBackup();

      expect(report, isNull);
      expect(file.existsSync(), isTrue);
      expect(restarts, 0);
    });
  });

  group('DatabaseGate', () {
    Future<void> pump(WidgetTester tester, DatabaseHealth health) async {
      final gated = ProviderContainer(
        parent: container,
        overrides: [databaseHealthProvider.overrideWith((ref) async => health)],
      );
      addTearDown(gated.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: gated,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            builder: (context, child) =>
                DatabaseGate(child: child ?? const SizedBox()),
            home: const Scaffold(body: Text('private journal text')),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('lets a healthy store through to the app', (tester) async {
      await pump(tester, const DatabaseHealthy());

      expect(find.text('private journal text'), findsOneWidget);
    });

    testWidgets('shows recovery, and nothing of the app, when broken', (
      tester,
    ) async {
      await pump(tester, DatabaseUnopenable(Exception('boom')));

      expect(find.text('private journal text'), findsNothing);
      expect(find.text('Import a backup'), findsOneWidget);
      expect(find.text('Reset local database'), findsOneWidget);
    });

    testWidgets('asks before resetting, and says the data goes', (
      tester,
    ) async {
      await pump(tester, DatabaseUnopenable(Exception('boom')));

      await tester.tap(find.text('Reset local database'));
      await tester.pumpAndSettle();

      expect(find.textContaining('permanently deleted'), findsOneWidget);
      expect(file.existsSync(), isTrue);
      expect(restarts, 0);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(restarts, 0);
    });

    testWidgets('resets once confirmed', (tester) async {
      await pump(tester, DatabaseUnopenable(Exception('boom')));

      await tester.tap(find.text('Reset local database'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset'));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(restarts, 1);
    });
  });
}
