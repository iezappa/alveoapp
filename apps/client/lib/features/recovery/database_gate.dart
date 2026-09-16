import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/local/database_health.dart';
import '../../data/providers.dart';
import '../../domain/transfer/import_report.dart';
import '../../l10n/app_localizations.dart';
import 'recovery_actions.dart';

/// Stands between the app and a database that would not open.
///
/// Without it, a store that fails to open fails every screen at once and
/// leaves nothing on screen to act on. With it, the user gets two explicit
/// ways out. Nothing is ever reset automatically.
///
/// It sits outside the PIN lock on purpose: the PIN lives in the same store,
/// so a broken store cannot be unlocked. The recovery screen reads nothing
/// from the store and shows no user data.
///
/// While the check runs the app is shown as usual: the screens are waiting
/// on the same open, and a spinner over them would only delay a healthy
/// launch.
class DatabaseGate extends ConsumerWidget {
  const DatabaseGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(databaseHealthProvider).asData?.value;
    if (health is! DatabaseUnopenable) return child;

    // Its own navigator: this replaces the app's, and the confirmation
    // dialogs need one to open on.
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const DatabaseRecoveryScreen(),
      ),
    );
  }
}

class DatabaseRecoveryScreen extends ConsumerStatefulWidget {
  const DatabaseRecoveryScreen({super.key});

  @override
  ConsumerState<DatabaseRecoveryScreen> createState() =>
      _DatabaseRecoveryScreenState();
}

class _DatabaseRecoveryScreenState
    extends ConsumerState<DatabaseRecoveryScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String action,
  }) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (!await _confirm(
      title: l10n.recoveryImportConfirmTitle,
      body: l10n.recoveryImportConfirmBody,
      action: l10n.recoveryImport,
    )) {
      return;
    }

    await _run(() async {
      try {
        await ref.read(databaseRecoveryActionsProvider).importBackup();
      } on ImportException catch (e) {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.importFailed(e.message))),
        );
      } on Object {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.recoveryImportFailed)),
        );
      }
    });
  }

  Future<void> _reset() async {
    final l10n = AppLocalizations.of(context);
    if (!await _confirm(
      title: l10n.recoveryResetConfirmTitle,
      body: l10n.recoveryResetConfirmBody,
      action: l10n.recoveryResetConfirmAction,
    )) {
      return;
    }

    await _run(ref.read(databaseRecoveryActionsProvider).reset);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
            child: ListView(
              padding: const EdgeInsets.all(kGutter),
              children: [
                const SizedBox(height: 24),
                Icon(
                  Icons.report_problem_outlined,
                  size: 56,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.recoveryTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.recoveryBody,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _busy ? null : _import,
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l10n.recoveryImport),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _reset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  icon: const Icon(Icons.restart_alt),
                  label: Text(l10n.recoveryReset),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
