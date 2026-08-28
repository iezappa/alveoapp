import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../l10n/app_localizations.dart';
import '../export/session_pdf_export.dart';
import 'session_providers.dart';

/// Read-only view of one session for the detail pane. "Edit" hands off to the
/// full session editor.
class SessionPreview extends ConsumerWidget {
  const SessionPreview({
    super.key,
    required this.sessionId,
    required this.onEdit,
    required this.onDelete,
  });

  final String sessionId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final session = ref.watch(sessionByIdProvider(sessionId));

    if (session == null) {
      return EmptyState(
        icon: Icons.chevron_left,
        message: l10n.detailNothingSelected,
      );
    }

    final sections = <(String, String?)>[
      (l10n.sessionAgenda, session.agendaMarkdown),
      (l10n.sessionNotes, session.notesMarkdown),
      (l10n.sessionTakeaways, session.takeawaysMarkdown),
    ].where((s) => (s.$2 ?? '').trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat.yMMMMEEEEd(
                    locale,
                  ).add_jm().format(session.scheduledFor),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () => runSessionPdfExport(context, session),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                tooltip: l10n.sessionExportPdf,
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.editAction),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.deleteAction,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: sections.isEmpty
              ? EmptyState(
                  icon: Icons.notes_outlined,
                  message: l10n.sessionPreviewEmpty,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  children: [
                    for (final (label, body) in sections)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionLabel(label),
                            const SizedBox(height: 6),
                            Text(
                              body!.trim(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
