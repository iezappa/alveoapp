import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import 'file_saver.dart';
import 'sensitive_export_warning.dart';

String _fileName(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}.md';

/// Prompts for a day, renders it to Markdown, and saves it to a file the user
/// chooses. A no-op if the user cancels either prompt.
Future<void> runDailyExport(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final now = DateTime.now();

  final day = await showDatePicker(
    context: context,
    initialDate: DateTime(now.year, now.month, now.day),
    firstDate: DateTime(2000),
    lastDate: DateTime(now.year, now.month, now.day),
  );
  if (day == null) return;

  final service = ref.read(exportServiceProvider);
  final data = await service.buildDailyExport(day);
  if (data.isEmpty) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.exportNothing)));
    return;
  }

  if (!context.mounted || !await confirmSensitiveExport(context)) return;

  final markdown = await service.buildDailyMarkdown(
    day,
    emotionLabel: l10n.emotionLabel,
  );

  final saved = await saveTextFile(
    suggestedName: _fileName(day),
    contents: markdown,
    typeLabel: l10n.exportMarkdownType,
    extensions: const ['md'],
  );
  if (saved == null) return;

  messenger.showSnackBar(SnackBar(content: Text(l10n.exportSaved(saved))));
}
