import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/obsidian/obsidian_report.dart';
import '../../l10n/app_localizations.dart';
import '../journal/journal_providers.dart';
import '../timeline/timeline_providers.dart';

/// Lets the user choose the vault folder and stores it.
Future<void> pickObsidianVault(BuildContext context, WidgetRef ref) async {
  final path = await getDirectoryPath();
  if (path == null) return;
  await ref.read(settingsRepositoryProvider).set(obsidianVaultKey, path);
  ref.invalidate(obsidianVaultProvider);
}

Future<void> runObsidianExport(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final vault = await ref
      .read(settingsRepositoryProvider)
      .get(obsidianVaultKey);
  if (vault == null) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.obsidianNoVault)));
    return;
  }

  try {
    final report = await ref.read(obsidianServiceProvider).exportJournal(vault);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.obsidianExported(report.exported))),
    );
  } on ObsidianException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  }
}

Future<void> runObsidianImport(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final vault = await ref
      .read(settingsRepositoryProvider)
      .get(obsidianVaultKey);
  if (vault == null) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.obsidianNoVault)));
    return;
  }

  try {
    final report = await ref.read(obsidianServiceProvider).importJournal(vault);
    ref.invalidate(journalListProvider);
    ref.invalidate(timelineProvider);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.obsidianImported(report.created, report.updated)),
      ),
    );
  } on ObsidianException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  }
}
