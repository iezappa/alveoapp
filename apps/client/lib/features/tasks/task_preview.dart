import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/local/tables.dart';
import '../../l10n/app_localizations.dart';
import 'task_providers.dart';

/// Read-only view of one task for the detail pane. "Edit" hands off to the
/// full task editor.
class TaskPreview extends ConsumerWidget {
  const TaskPreview({
    super.key,
    required this.taskId,
    required this.onEdit,
    required this.onDelete,
  });

  final String taskId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static String statusLabel(AppLocalizations l10n, TaskStatus status) =>
      switch (status) {
        TaskStatus.pending => l10n.taskStatusPending,
        TaskStatus.inProgress => l10n.taskStatusInProgress,
        TaskStatus.done => l10n.taskStatusDone,
        TaskStatus.skipped => l10n.taskStatusSkipped,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final task = ref.watch(taskByIdProvider(taskId));

    if (task == null) {
      return EmptyState(
        icon: Icons.chevron_left,
        message: l10n.detailNothingSelected,
      );
    }

    final description = task.descriptionMarkdown?.trim() ?? '';
    final closingNote = task.closingNote?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(task.title, style: theme.textTheme.titleMedium),
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(label: Text(statusLabel(l10n, task.status))),
                  if (task.dueDate != null)
                    Text(
                      '${l10n.taskDueDate}: '
                      '${DateFormat.yMMMd(locale).format(task.dueDate!)}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(description, style: theme.textTheme.bodyLarge),
              ],
              if (closingNote.isNotEmpty) ...[
                const SizedBox(height: 20),
                SectionLabel(l10n.taskClosingNote),
                const SizedBox(height: 6),
                Text(closingNote, style: theme.textTheme.bodyLarge),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
