import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import 'journal_labels.dart';
import 'journal_providers.dart';

/// Read-only view of one journal entry for the detail pane. "Edit" hands off
/// to the full Markdown editor.
class JournalPreview extends ConsumerWidget {
  const JournalPreview({
    super.key,
    required this.entryId,
    required this.onEdit,
    required this.onDelete,
  });

  final String entryId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final entry = ref.watch(journalEntryByIdProvider(entryId));

    if (entry == null) {
      return EmptyState(
        icon: Icons.chevron_left,
        message: l10n.detailNothingSelected,
      );
    }

    final title = (entry.title ?? '').trim();
    final emotions =
        ref.watch(journalEmotionsProvider(entryId)).asData?.value ??
        const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.isEmpty ? l10n.journalUntitled : title,
                  style: theme.textTheme.titleMedium,
                ),
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
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(
                    avatar: Icon(entry.section.icon, size: 16),
                    label: Text(entry.section.label(l10n)),
                  ),
                  Text(
                    DateFormat.yMMMMd(locale).format(entry.entryDate),
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if (entry.isMonthlyReview)
                    Text(
                      l10n.monthlyReview,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                ],
              ),
              if (emotions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final key in emotions)
                      Chip(
                        label: Text(l10n.emotionLabel(key)),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Text(entry.bodyMarkdown, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
