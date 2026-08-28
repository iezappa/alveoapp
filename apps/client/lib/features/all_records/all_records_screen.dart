import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../domain/all_records/text_record.dart';
import '../../l10n/app_localizations.dart';
import 'all_records_providers.dart';

/// A read-only stream of every text the user has written, newest first —
/// journal entries, session notes, thought records, tasks and check-in notes,
/// all in one place.
class AllRecordsScreen extends ConsumerWidget {
  const AllRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final records = ref.watch(allTextRecordsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.allRecordsTitle)),
      body: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.notes_outlined,
              message: l10n.allRecordsEmpty,
            );
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  kGutter,
                  kGutter,
                  kGutter,
                  32,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _RecordCard(record: items[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final TextRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final (icon, kindLabel) = _kindMeta(l10n, record.kind);
    final title = record.title?.trim() ?? '';
    final body = record.body.trim();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  kindLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat.yMMMd(locale).format(record.when),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(title, style: theme.textTheme.titleMedium),
            ],
            if (body.isNotEmpty) ...[
              const SizedBox(height: 6),
              SelectableText(
                body,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

(IconData, String) _kindMeta(AppLocalizations l10n, TextRecordKind kind) =>
    switch (kind) {
      TextRecordKind.journal => (Icons.book_outlined, l10n.navJournal),
      TextRecordKind.session => (Icons.event_note_outlined, l10n.navSessions),
      TextRecordKind.task => (Icons.checklist_outlined, l10n.navTasks),
      TextRecordKind.thoughtRecord => (
        Icons.psychology_outlined,
        l10n.allRecordsKindThought,
      ),
      TextRecordKind.mood => (
        Icons.favorite_outline,
        l10n.allRecordsKindMood,
      ),
    };
