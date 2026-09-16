import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/clock.dart';
import '../../data/providers.dart';
import '../../domain/backup/backup_reminder.dart';
import '../../l10n/app_localizations.dart';
import 'backup_actions.dart';

/// Whether to nudge the user to export. Invalidated after an export or a
/// snooze.
final backupReminderProvider = FutureProvider<BackupReminder>((ref) async {
  final history = ref.watch(backupHistoryProvider);

  return backupReminderFor(
    now: ref.watch(clockProvider)(),
    lastExportAt: await history.lastExportAt(),
    dismissedAt: await history.reminderDismissedAt(),
    holdsData: await ref.watch(dataEraserProvider).holdsUserData(),
  );
});

/// The periodic nudge to export, docked under the open tab.
///
/// Non-blocking and easy to put off, because a reminder that gets in the way
/// gets dismissed without being read. What it never does is disappear for
/// good: "not now" snoozes it, and only an export resets the count.
class BackupReminderBanner extends ConsumerWidget {
  const BackupReminderBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminder = ref.watch(backupReminderProvider).asData?.value;
    final l10n = AppLocalizations.of(context);

    final message = switch (reminder) {
      BackupNeverTaken() => l10n.backupReminderNever,
      BackupOverdue(:final days) => l10n.backupReminderOverdue(days),
      NoBackupReminder() || null => null,
    };
    if (message == null) return const SizedBox.shrink();

    return MaterialBanner(
      leading: const Icon(Icons.backup_outlined),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () async {
            await ref
                .read(backupHistoryProvider)
                .snoozeReminder(ref.read(clockProvider)());
            ref.invalidate(backupReminderProvider);
          },
          child: Text(l10n.backupReminderDismiss),
        ),
        FilledButton.tonal(
          onPressed: () => runExportBackup(context, ref),
          child: Text(l10n.backupReminderAction),
        ),
      ],
    );
  }
}
