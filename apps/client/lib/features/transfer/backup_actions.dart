import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/clock.dart';
import '../../data/providers.dart';
import '../../domain/transfer/import_report.dart';
import '../../l10n/app_localizations.dart';
import '../export/file_saver_provider.dart';
import '../export/sensitive_export_warning.dart';
import '../journal/journal_providers.dart';
import '../sessions/session_providers.dart';
import '../tasks/task_providers.dart';
import 'backup_reminder_banner.dart';

String _backupName() {
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return 'alveo-backup-${now.year}-${two(now.month)}-${two(now.day)}.json';
}

/// Writes a spreadsheet-readable CSV of every record. Not a backup: it
/// cannot be imported, so it does not count towards the backup reminder.
Future<void> runExportCsv(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  if (!await confirmSensitiveExport(context)) return;

  final csv = await ref.read(csvExportServiceProvider).exportToCsv();
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  final saved = await ref.read(textFileSaverProvider)(
    suggestedName:
        'alveo-export-${now.year}-${two(now.month)}-${two(now.day)}.csv',
    contents: csv,
    typeLabel: l10n.csvFileType,
    extensions: const ['csv'],
  );
  if (saved == null) return;
  messenger.showSnackBar(SnackBar(content: Text(l10n.csvSaved)));
}

/// Writes a full-database backup to a file the user chooses.
Future<void> runExportBackup(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  if (!await confirmSensitiveExport(context)) return;

  final json = await ref.read(backupServiceProvider).exportToJson();

  final saved = await ref.read(textFileSaverProvider)(
    suggestedName: _backupName(),
    contents: json,
    typeLabel: l10n.backupFileType,
    extensions: const ['json'],
  );
  if (saved == null) return;

  await ref.read(backupHistoryProvider).recordExport(ref.read(clockProvider)());
  ref.invalidate(backupReminderProvider);

  messenger.showSnackBar(SnackBar(content: Text(l10n.backupSaved)));
}

/// Reads a backup file and merges it into the local database, skipping
/// records that are already present.
///
/// Nothing local is ever replaced or deleted, so there is nothing to export
/// first: an import can only add.
Future<void> runImportBackup(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final file = await openFile(
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.backupFileType, extensions: const ['json']),
    ],
  );
  if (file == null) return;

  final ImportReport report;
  try {
    final source = await file.readAsString();
    report = await ref.read(backupServiceProvider).importFromJson(source);
  } on ImportException catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.importFailed(e.message))),
    );
    return;
  }

  ref.invalidate(journalListProvider);
  ref.invalidate(taskListProvider);
  ref.invalidate(sessionListProvider);

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.importDone),
      content: Text(
        l10n.importSummary(report.totalInserted, report.totalSkipped),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.saveButton),
        ),
      ],
    ),
  );
}
