import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../domain/journal/journal_section.dart';
import '../../l10n/app_localizations.dart';
import '../shared/confirm_delete.dart';
import '../shared/save_failure.dart';
import '../shared/master_detail_shell.dart';
import 'journal_editor_screen.dart';
import 'journal_labels.dart';
import 'journal_preview.dart';
import 'journal_providers.dart';

/// The journal as a master-detail screen: entries on the left (filterable by
/// notebook section), a read-only preview of the selected one on the right.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _search = TextEditingController();
  final _sections = <JournalSection>{};
  String? _selectedId;
  bool _editingSelected = false;
  JournalSection? _creatingSection;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(String id) {
    if (MasterDetailShell.isWide(context)) {
      setState(() {
        _selectedId = id;
        _creatingSection = null;
        _editingSelected = false;
      });
    } else {
      context.push('/journal/$id');
    }
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context);
    final section = await showModalBottomSheet<JournalSection>(
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final s in JournalSection.values)
                ListTile(
                  leading: Icon(s.icon),
                  title: Text(s.label(l10n)),
                  onTap: () => Navigator.pop(context, s),
                ),
            ],
          ),
        ),
      ),
    );
    if (section == null || !mounted) return;
    if (MasterDetailShell.isWide(context)) {
      setState(() {
        _creatingSection = section;
        _editingSelected = false;
      });
    } else {
      context.push('/journal/new?section=${section.name}');
    }
  }

  void _exitEditor() {
    if (mounted) {
      setState(() {
        _creatingSection = null;
        _editingSelected = false;
      });
    }
  }

  Future<void> _delete(String id) async {
    if (!await confirmDelete(context) || !mounted) return;
    final deleted = await deleteOrReport(
      context,
      () => ref.read(journalRepositoryProvider).delete(id),
    );
    if (!deleted) return;
    ref.invalidate(journalListProvider);
    if (mounted) setState(() => _selectedId = null);
  }

  List<JournalEntry> _filter(List<JournalEntry> all) {
    final query = _search.text.trim().toLowerCase();
    return all.where((e) {
      if (_sections.isNotEmpty && !_sections.contains(e.section)) return false;
      if (query.isEmpty) return true;
      return (e.title ?? '').toLowerCase().contains(query) ||
          e.bodyMarkdown.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MasterDetailShell.isWide(context);
    final entries = ref.watch(journalListProvider);

    final list = RecordListPane(
      searchController: _search,
      onSearchChanged: (_) => setState(() {}),
      searchHint: l10n.journalSearchHint,
      addTooltip: l10n.journalNewTitle,
      onAdd: _add,
      filters: [
        for (final section in JournalSection.values)
          FilterChip(
            label: Text(section.label(l10n)),
            selected: _sections.contains(section),
            onSelected: (on) => setState(() {
              on ? _sections.add(section) : _sections.remove(section);
            }),
          ),
      ],
      child: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final items = _filter(all);
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.book_outlined,
              message: l10n.journalSectionEmpty,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 2),
            itemBuilder: (context, i) => _tile(items[i], wide),
          );
        },
      ),
    );

    final Widget detail;
    if (_creatingSection != null) {
      detail = JournalEditorScreen(
        key: ValueKey('journal-editor-new-${_creatingSection!.name}'),
        section: _creatingSection!,
        onDone: _exitEditor,
      );
    } else if (_editingSelected && _selectedId != null) {
      detail = JournalEditorScreen(
        key: ValueKey('journal-editor-$_selectedId'),
        entryId: _selectedId,
        onDone: _exitEditor,
      );
    } else if (_selectedId != null) {
      detail = JournalPreview(
        key: ValueKey(_selectedId),
        entryId: _selectedId!,
        onEdit: () => setState(() => _editingSelected = true),
        onDelete: () => _delete(_selectedId!),
      );
    } else {
      detail = EmptyState(
        icon: Icons.chevron_left,
        message: l10n.detailNothingSelected,
      );
    }

    return MasterDetailShell(
      title: l10n.navJournal,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
          tooltip: l10n.navSettings,
        ),
        const SizedBox(width: 4),
      ],
      list: list,
      detail: detail,
    );
  }

  Widget _tile(JournalEntry entry, bool wide) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final title = (entry.title ?? '').trim();

    return ListTile(
      selected: wide && entry.id == _selectedId,
      selectedTileColor: scheme.secondaryContainer.withValues(alpha: 0.5),
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Icon(entry.section.icon, size: 20),
      ),
      title: Text(
        title.isEmpty ? l10n.journalUntitled : title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${entry.section.label(l10n)}  ·  '
        '${DateFormat.yMMMd(locale).format(entry.entryDate)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _open(entry.id),
    );
  }
}
