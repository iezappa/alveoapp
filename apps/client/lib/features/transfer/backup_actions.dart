import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/transfer/import_report.dart';
import '../../l10n/app_localizations.dart';
import '../journal/journal_providers.dart';
import '../sessions/session_providers.dart';
import '../tasks/task_providers.dart';
import '../timeline/timeline_providers.dart';

String _backupName() {
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return 'alveo-backup-${now.year}-${two(now.month)}-${two(now.day)}.json';
}

/// Writes a full-database backup to a file the user chooses.
Future<void> runExportBackup(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final json = await ref.read(backupServiceProvider).exportToJson();

  final location = await getSaveLocation(
    suggestedName: _backupName(),
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.backupFileType, extensions: const ['json']),
    ],
  );
  if (location == null) return;

  await File(location.path).writeAsString(json);
  messenger.showSnackBar(SnackBar(content: Text(l10n.backupSaved)));
}

/// Reads a backup file and merges it into the local database, skipping
/// records that are already present.
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

  ref.invalidate(timelineProvider);
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
