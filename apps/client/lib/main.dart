import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/locale_controller.dart';
import 'app/router.dart';
import 'data/local/database.dart';
import 'data/providers.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase.file(await defaultDatabaseFile());
  final container = ProviderContainer(
    overrides: [appDatabaseProvider.overrideWithValue(database)],
  );
  await container.read(localeControllerProvider.notifier).load();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TerapiaApp(),
    ),
  );
}

class TerapiaApp extends ConsumerWidget {
  const TerapiaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4C6FFF),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
