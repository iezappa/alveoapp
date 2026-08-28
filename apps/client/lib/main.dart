import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/lock_controller.dart';
import 'app/locale_controller.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'app/theme_controller.dart';
import 'data/local/database.dart';
import 'data/providers.dart';
import 'features/security/lock_screen.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase.connect();
  final container = ProviderContainer(
    overrides: [appDatabaseProvider.overrideWithValue(database)],
  );
  await container.read(localeControllerProvider.notifier).load();
  await container.read(themeControllerProvider.notifier).load();
  await container.read(lockControllerProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const AlveoApp()),
  );
}

class AlveoApp extends ConsumerStatefulWidget {
  const AlveoApp({super.key});

  @override
  ConsumerState<AlveoApp> createState() => _AlveoAppState();
}

class _AlveoAppState extends ConsumerState<AlveoApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      ref.read(lockControllerProvider.notifier).lockIfProtected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    final theme = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildLightTheme(theme.accent),
      darkTheme: buildDarkTheme(theme.accent),
      themeMode: theme.mode,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final locked = ref.watch(lockControllerProvider);
        if (!locked) return child ?? const SizedBox.shrink();
        // Host the lock screen in its own Overlay: replacing `child` removes
        // the Navigator, and text fields need an Overlay ancestor.
        return Overlay(
          initialEntries: [OverlayEntry(builder: (_) => const LockScreen())],
        );
      },
    );
  }
}
