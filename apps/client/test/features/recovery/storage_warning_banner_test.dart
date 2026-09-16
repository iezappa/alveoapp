import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/storage_durability.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/export/file_saver_provider.dart';
import 'package:alveo/features/recovery/storage_warning_banner.dart';
import 'package:alveo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  String? savedContents;

  setUp(() {
    db = AppDatabase.forTesting();
    savedContents = null;
  });
  tearDown(() => db.close());

  Future<ProviderContainer> pump(
    WidgetTester tester,
    StorageDurability durability,
  ) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        textFileSaverProvider.overrideWithValue(({
          required suggestedName,
          required contents,
          required typeLabel,
          required extensions,
        }) async {
          savedContents = contents;
          return suggestedName;
        }),
      ],
    );
    addTearDown(container.dispose);
    container.read(storageDurabilityProvider.notifier).report(durability);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(body: StorageWarningBanner()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('says nothing on storage that can be trusted', (tester) async {
    await pump(tester, StorageDurability.durable);

    expect(find.byType(MaterialBanner), findsNothing);
  });

  testWidgets('warns that IndexedDB can lose data', (tester) async {
    await pump(tester, StorageDurability.degraded);

    expect(find.textContaining('may be lost'), findsOneWidget);
    expect(find.text('Export now'), findsOneWidget);
  });

  testWidgets('warns harder when nothing is stored at all', (tester) async {
    await pump(tester, StorageDurability.volatile);

    expect(find.textContaining('will be lost when you close'), findsOneWidget);
  });

  testWidgets('exports from the banner itself', (tester) async {
    await pump(tester, StorageDurability.degraded);

    await tester.tap(find.text('Export now'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue')); // the unencrypted-file warning
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(savedContents, contains('alveo-export'));
  });

  testWidgets('goes away for the session once dismissed', (tester) async {
    final container = await pump(tester, StorageDurability.degraded);

    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialBanner), findsNothing);
    expect(container.read(storageWarningDismissedProvider), isTrue);
  });
}
