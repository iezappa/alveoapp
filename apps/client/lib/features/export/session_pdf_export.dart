import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/export/pdf_export.dart';
import '../../data/local/database.dart';
import '../../l10n/app_localizations.dart';

String _fileName(DateTime when) =>
    'session-'
    '${when.year.toString().padLeft(4, '0')}-'
    '${when.month.toString().padLeft(2, '0')}-'
    '${when.day.toString().padLeft(2, '0')}.pdf';

/// Builds a PDF for [session] and writes it to a file the user chooses.
/// A no-op if they cancel the save dialog.
Future<void> runSessionPdfExport(
  BuildContext context,
  Session session,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final locale = Localizations.localeOf(context).toString();

  final bytes = await buildSessionPdf(
    session,
    SessionPdfLabels(
      title: l10n.sessionExportTitle,
      dateText: DateFormat.yMMMMEEEEd(
        locale,
      ).add_jm().format(session.scheduledFor),
      agenda: l10n.sessionAgenda,
      notes: l10n.sessionNotes,
      takeaways: l10n.sessionTakeaways,
    ),
  );

  final location = await getSaveLocation(
    suggestedName: _fileName(session.scheduledFor),
    acceptedTypeGroups: [
      const XTypeGroup(label: 'PDF', extensions: ['pdf']),
    ],
  );
  if (location == null) return;

  await File(location.path).writeAsBytes(bytes);
  messenger.showSnackBar(
    SnackBar(content: Text(l10n.exportSaved(location.path))),
  );
}
