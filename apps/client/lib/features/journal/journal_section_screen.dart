import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../domain/journal/journal_section.dart';
import '../../l10n/app_localizations.dart';
import 'journal_labels.dart';
import 'journal_providers.dart';

class JournalSectionScreen extends ConsumerWidget {
  const JournalSectionScreen({super.key, required this.section});

  final JournalSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(journalSectionEntriesProvider(section));

    return Scaffold(
      appBar: AppBar(title: Text(section.label(l10n))),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: section.icon,
              message: l10n.journalSectionEmpty,
            );
          }
          final body = section == JournalSection.oneLiner
              ? _OneLinerView(entries: items)
              : _PlainList(entries: items);
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: body,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/journal/new?section=${section.name}'),
        icon: const Icon(Icons.add),
        label: Text(l10n.journalNewTitle),
      ),
    );
  }
}

String _firstLine(JournalEntry e) {
  final title = e.title?.trim();
  if (title != null && title.isNotEmpty) return title;
  final line = e.bodyMarkdown.trim().split('\n').first.trim();
  return line.replaceFirst(RegExp(r'^#+\s*'), '');
}

class _PlainList extends StatelessWidget {
  const _PlainList({required this.entries});

  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kGutter, vertical: 8),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, i) {
        final e = entries[i];
        return ListTile(
          title: Text(
            _firstLine(e),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(DateFormat.yMMMd(locale).format(e.entryDate)),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push('/journal/${e.id}'),
        );
      },
    );
  }
}

/// One-liner section: entries grouped by month, each month showing its
/// monthly review (or an invite to write one) above the day lines.
class _OneLinerView extends StatelessWidget {
  const _OneLinerView({required this.entries});

  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    final byMonth = <DateTime, List<JournalEntry>>{};
    for (final e in entries) {
      final key = DateTime(e.entryDate.year, e.entryDate.month);
      byMonth.putIfAbsent(key, () => []).add(e);
    }
    final months = byMonth.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.fromLTRB(kGutter, kGutter, kGutter, 8),
      children: [
        for (final month in months) ...[
          SectionLabel(DateFormat.yMMMM(locale).format(month)),
          const SizedBox(height: 4),
          _MonthReview(month: month, entries: byMonth[month]!),
          const SizedBox(height: 4),
          for (final e in byMonth[month]!.where((e) => !e.isMonthlyReview))
            _DayLine(entry: e),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _MonthReview extends StatelessWidget {
  const _MonthReview({required this.month, required this.entries});

  final DateTime month;
  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reviews = entries.where((e) => e.isMonthlyReview).toList();
    final review = reviews.isEmpty ? null : reviews.first;

    if (review == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => context.push(
            '/journal/new?section=${JournalSection.oneLiner.name}'
            '&review=${month.year}-${month.month}',
          ),
          icon: const Icon(Icons.rate_review_outlined, size: 18),
          label: Text(l10n.writeMonthlyReview),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: const Icon(Icons.rate_review_outlined),
        title: Text(l10n.monthlyReview),
        subtitle: Text(
          _firstLine(review),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => context.push('/journal/${review.id}'),
      ),
    );
  }
}

class _DayLine extends StatelessWidget {
  const _DayLine({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push('/journal/${entry.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Text(
                DateFormat.d(locale).format(entry.entryDate),
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: Text(
                _firstLine(entry),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
