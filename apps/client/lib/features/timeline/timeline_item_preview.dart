import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../domain/timeline/timeline_item.dart';
import '../../l10n/app_localizations.dart';
import '../tasks/task_preview.dart';

/// The editor route for a timeline item, or `null` if the type has no editor
/// (mood check-ins are not editable).
String? timelineItemRoute(TimelineItem item) => switch (item) {
  JournalTimelineItem(:final entry) => '/journal/${entry.id}',
  TaskTimelineItem(:final task) => '/tasks/${task.id}',
  SessionTimelineItem(:final session) => '/sessions/${session.id}',
  _ => null,
};

/// Read-only view of one timeline item for the detail pane.
class TimelineItemPreview extends StatelessWidget {
  const TimelineItemPreview({super.key, required this.item});

  final TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final route = timelineItemRoute(item);

    final (String title, List<Widget> body) = switch (item) {
      MoodTimelineItem(:final entry) => (
        l10n.timelineMoodLabel(entry.mood),
        [
          if ((entry.note ?? '').trim().isNotEmpty)
            Text(entry.note!.trim(), style: theme.textTheme.bodyLarge),
        ],
      ),
      JournalTimelineItem(:final entry) => (
        (entry.title ?? '').trim().isEmpty
            ? l10n.journalUntitled
            : entry.title!.trim(),
        [Text(entry.bodyMarkdown, style: theme.textTheme.bodyLarge)],
      ),
      TaskTimelineItem(:final task) => (
        task.title,
        [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Chip(
              label: Text(TaskPreview.statusLabel(l10n, task.status)),
            ),
          ),
          if ((task.descriptionMarkdown ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              task.descriptionMarkdown!.trim(),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ],
      ),
      SessionTimelineItem(:final session) => (
        l10n.sessionTimelineLabel,
        [
          for (final (label, text) in <(String, String?)>[
            (l10n.sessionAgenda, session.agendaMarkdown),
            (l10n.sessionNotes, session.notesMarkdown),
            (l10n.sessionTakeaways, session.takeawaysMarkdown),
          ])
            if ((text ?? '').trim().isNotEmpty) ...[
              SectionLabel(label),
              const SizedBox(height: 6),
              Text(text!.trim(), style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
            ],
        ],
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    Text(
                      DateFormat.yMMMMEEEEd(
                        locale,
                      ).add_jm().format(item.occurredAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (route != null)
                TextButton.icon(
                  onPressed: () => context.push(route),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(l10n.editAction),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: body.isEmpty
              ? EmptyState(
                  icon: Icons.notes_outlined,
                  message: l10n.timelinePreviewEmpty,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  children: body,
                ),
        ),
      ],
    );
  }
}
