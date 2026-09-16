import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/export/pdf_export.dart';
import '../../data/local/database.dart';
import '../../l10n/app_localizations.dart';
import 'file_saver.dart';
import 'sensitive_export_warning.dart';

String _fileName(DateTime when) =>
    'session-'
    '${when.year.toString().padLeft(4, '0')}-'
    '${when.month.toString().padLeft(2, '0')}-'
    '${when.day.toString().padLeft(2, '0')}.pdf';

/// Builds a PDF for [session] and writes it to a file the user chooses.
/// A no-op if they cancel the save dialog.
Future<void> runSessionPdfExport(
  BuildContext context,
  WidgetRef ref,
  Session session,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final locale = Localizations.localeOf(context).toString();

  if (!await confirmSensitiveExport(context, ref)) return;

  final bytes = await buildSessionPdf(
    session,
    SessionPdfLabels(
      title: l10n.sessionExportTitle,
      dateText: DateFormat.yMMMMEEEEd(locale)
          .add_jm()
          .format(session.scheduledFor),
      agenda: l10n.sessionAgenda,
      notes: l10n.sessionNotes,
      takeaways: l10n.sessionTakeaways,
    ),
  );

  final saved = await saveBytesFile(
    suggestedName: _fileName(session.scheduledFor),
    bytes: bytes,
    typeLabel: 'PDF',
    extensions: const ['pdf'],
  );
  if (saved == null) return;

  messenger.showSnackBar(SnackBar(content: Text(l10n.exportSaved(saved))));
}
