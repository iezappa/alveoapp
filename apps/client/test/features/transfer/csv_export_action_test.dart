import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/providers.dart';
import 'package:alveo/features/export/file_saver_provider.dart';
import 'package:alveo/features/transfer/backup_actions.dart';
import 'package:alveo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('warns, then saves a .csv spreadsheet export', (tester) async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    String? name;
    String? saved;
    List<String>? types;

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
            name = suggestedName;
            saved = contents;
            types = extensions;
            return suggestedName;
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: TextButton(
                onPressed: () => runExportCsv(context, ref),
                child: const Text('csv'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('csv'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text('Keep this file private'), findsOneWidget);
    expect(name, isNull);

    await tester.tap(find.text('Continue'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(name, matches(RegExp(r'^alveo-export-\d{4}-\d{2}-\d{2}\.csv$')));
    expect(types, ['csv']);
    expect(saved, contains('type,date,title,text,details'));
  });
}
