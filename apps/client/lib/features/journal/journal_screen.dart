import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../data/local/database.dart';
import '../../domain/journal/journal_section.dart';
import '../../l10n/app_localizations.dart';
import 'journal_labels.dart';
import 'journal_providers.dart';

/// The journal home: one row per notebook (section) with a count and the date
/// of the most recent entry.
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final entries = ref.watch(journalListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navJournal),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.navSettings,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final bySection = <JournalSection, List<JournalEntry>>{};
          for (final e in all) {
            bySection.putIfAbsent(e.section, () => []).add(e);
          }

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: kGutter,
                  vertical: 8,
                ),
                children: [
                  for (final section in JournalSection.values)
                    _SectionRow(
                      section: section,
                      entries: bySection[section] ?? const [],
                      locale: locale,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/journal/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.journalNewTitle),
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.section,
    required this.entries,
    required this.locale,
  });

  final JournalSection section;
  final List<JournalEntry> entries;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final subtitle = entries.isEmpty
        ? l10n.journalSectionEmpty
        : '${l10n.journalEntryCount(entries.length)}  ·  '
              '${DateFormat.yMMMd(locale).format(entries.first.entryDate)}';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Icon(section.icon, size: 20),
      ),
      title: Text(section.label(l10n)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push('/journal/section/${section.name}'),
    );
  }
}
