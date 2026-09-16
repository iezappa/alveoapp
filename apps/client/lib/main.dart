import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_restart.dart';
import 'app/lock_controller.dart';
import 'app/locale_controller.dart';
import 'app/onboarding_controller.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'app/theme_controller.dart';
import 'app/user_profile_controller.dart';
import 'data/local/database.dart';
import 'data/local/database_health.dart';
import 'data/local/persistent_storage.dart';
import 'data/providers.dart';
import 'features/recovery/database_gate.dart';
import 'features/security/lock_screen.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Not awaited: the browser may take its time, or prompt, and a launch must
  // not wait on either. A no-op outside the web.
  unawaited(requestPersistentStorage());

  runApp(
    AppRestartHost(
      bootstrap: bootstrapApp,
      beforeDispose: (container) async {
        try {
          await container.read(appDatabaseProvider).close();
        } on Object {
          // A store that never opened can fail to close as well.
        }
      },
      child: const AlveoApp(),
    ),
  );
}

/// Opens the database and loads what the first frame needs.
///
/// Run again from scratch whenever the app restarts (after a recovery or
/// after erasing all data). Preferences live in the database, so they are
/// only read when it opened; a broken store goes straight to recovery.
Future<ProviderContainer> bootstrapApp(RestartApp restart) async {
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWith(
        (ref) => AppDatabase.connect(
          onStorageChosen: (durability) {
            try {
              ref.read(storageDurabilityProvider.notifier).report(durability);
            } on Object {
              // The container was thrown away before the store finished
              // opening; nobody is left to warn.
            }
          },
        ),
      ),
      firstRunFlowEnabledProvider.overrideWithValue(true),
      restartAppProvider.overrideWithValue(restart),
    ],
  );

  final health = await container.read(databaseHealthProvider.future);
  if (health is DatabaseHealthy) {
    await container.read(localeControllerProvider.notifier).load();
    await container.read(themeControllerProvider.notifier).load();
    await container.read(userProfileControllerProvider.notifier).load();
    await container.read(onboardingControllerProvider.notifier).load();
    await container.read(backupNoticeAcceptedProvider.notifier).load();
    await container.read(lockControllerProvider.notifier).initialize();
  }
  return container;
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
    // `main()` normally loads this before the first frame; a widget test that
    // pumps AlveoApp directly skips that bootstrap, so kick it off here when
    // nothing has loaded it yet — and only once the store is known to open.
    ref.read(databaseHealthProvider.future).then((health) {
      if (!mounted || health is! DatabaseHealthy) return;
      if (ref.read(userProfileControllerProvider) is AsyncLoading) {
        ref.read(userProfileControllerProvider.notifier).load();
      }
      if (ref.read(onboardingControllerProvider) is AsyncLoading) {
        ref.read(onboardingControllerProvider.notifier).load();
      }
      if (ref.read(backupNoticeAcceptedProvider) is AsyncLoading) {
        ref.read(backupNoticeAcceptedProvider.notifier).load();
      }
    });
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
        // The database gate goes first: a store that will not open cannot be
        // unlocked either (the PIN lives in it), and the recovery screen
        // shows no user data.
        final locked = ref.watch(lockControllerProvider);
        return DatabaseGate(
          child: locked
              // Host the lock screen in its own Overlay: replacing `child`
              // removes the Navigator, and text fields need an Overlay
              // ancestor.
              ? Overlay(
                  initialEntries: [
                    OverlayEntry(builder: (_) => const LockScreen()),
                  ],
                )
              : child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
