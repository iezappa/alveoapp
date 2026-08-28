import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../domain/timeline/timeline_item.dart';
import '../../l10n/app_localizations.dart';
import '../export/export_day.dart';
import '../shared/master_detail_shell.dart';
import '../tasks/task_preview.dart';
import 'timeline_item_preview.dart';
import 'timeline_providers.dart';

enum _Kind { mood, journal, task, session }

String _kindLabel(AppLocalizations l10n, _Kind kind) => switch (kind) {
  _Kind.mood => l10n.searchTypeMood,
  _Kind.journal => l10n.searchTypeJournal,
  _Kind.task => l10n.searchTypeTask,
  _Kind.session => l10n.searchTypeSession,
};

/// The unified activity feed as a master-detail screen: the merged list on the
/// left (filterable by record kind), a read-only preview of the selected item
/// on the right.
class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final _search = TextEditingController();
  final _kinds = <_Kind>{};
  String? _selectedKey;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _keyOf(TimelineItem item) => '${item.runtimeType}:${item.id}';

  _Kind _kindOf(TimelineItem item) => switch (item) {
    MoodTimelineItem() => _Kind.mood,
    JournalTimelineItem() => _Kind.journal,
    TaskTimelineItem() => _Kind.task,
    SessionTimelineItem() => _Kind.session,
  };

  String _searchText(TimelineItem item) => switch (item) {
    MoodTimelineItem(:final entry) => entry.note ?? '',
    JournalTimelineItem(:final entry) =>
      '${entry.title ?? ''} ${entry.bodyMarkdown}',
    TaskTimelineItem(:final task) =>
      '${task.title} ${task.descriptionMarkdown ?? ''}',
    SessionTimelineItem(:final session) => session.agendaMarkdown ?? '',
  };

  List<TimelineItem> _filter(List<TimelineItem> all) {
    final query = _search.text.trim().toLowerCase();
    return all.where((i) {
      if (_kinds.isNotEmpty && !_kinds.contains(_kindOf(i))) return false;
      if (query.isEmpty) return true;
      return _searchText(i).toLowerCase().contains(query);
    }).toList();
  }

  void _openItem(TimelineItem item) {
    final route = timelineItemRoute(item);
    if (MasterDetailShell.isWide(context)) {
      setState(() => _selectedKey = _keyOf(item));
    } else if (route != null) {
      context.push(route);
    }
  }

  Future<void> _add() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: Text(l10n.addCheckIn),
                onTap: () => Navigator.pop(context, '/check-in'),
              ),
              ListTile(
                leading: const Icon(Icons.notes_outlined),
                title: Text(l10n.journalNewTitle),
                onTap: () => Navigator.pop(context, '/journal/new'),
              ),
              ListTile(
                leading: const Icon(Icons.checklist_outlined),
                title: Text(l10n.newTask),
                onTap: () => Navigator.pop(context, '/tasks/new'),
              ),
            ],
          ),
        );
      },
    );
    if (choice != null && mounted) context.push(choice);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MasterDetailShell.isWide(context);
    final timeline = ref.watch(timelineProvider);

    final list = RecordListPane(
      searchController: _search,
      onSearchChanged: (_) => setState(() {}),
      searchHint: l10n.timelineSearchHint,
      addTooltip: l10n.addRecord,
      onAdd: _add,
      filters: [
        for (final kind in _Kind.values)
          FilterChip(
            label: Text(_kindLabel(l10n, kind)),
            selected: _kinds.contains(kind),
            onSelected: (on) => setState(() {
              on ? _kinds.add(kind) : _kinds.remove(kind);
            }),
          ),
      ],
      child: timeline.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final items = _filter(all);
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.timeline_outlined,
              message: l10n.timelineEmpty,
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

    TimelineItem? selected;
    for (final i in timeline.asData?.value ?? const <TimelineItem>[]) {
      if (_keyOf(i) == _selectedKey) {
        selected = i;
        break;
      }
    }

    final detail = selected == null
        ? EmptyState(
            icon: Icons.chevron_left,
            message: l10n.detailNothingSelected,
          )
        : TimelineItemPreview(key: ValueKey(_selectedKey), item: selected);

    return MasterDetailShell(
      title: l10n.navTimeline,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
          tooltip: l10n.search,
        ),
        IconButton(
          icon: const Icon(Icons.ios_share_outlined),
          onPressed: () => runDailyExport(context, ref),
          tooltip: l10n.exportDayTooltip,
        ),
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

  Widget _tile(TimelineItem item, bool wide) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.MMMd(locale).add_jm().format(item.occurredAt);

    final (IconData icon, String title, String? detail) = switch (item) {
      MoodTimelineItem(:final entry) => (
        Icons.favorite_outline,
        l10n.timelineMoodLabel(entry.mood),
        entry.note,
      ),
      JournalTimelineItem(:final entry) => (
        Icons.notes_outlined,
        (entry.title ?? '').trim().isEmpty
            ? l10n.journalUntitled
            : entry.title!.trim(),
        null,
      ),
      TaskTimelineItem(:final task) => (
        Icons.checklist_outlined,
        task.title,
        TaskPreview.statusLabel(l10n, task.status),
      ),
      SessionTimelineItem() => (
        Icons.psychology_outlined,
        l10n.sessionTimelineLabel,
        null,
      ),
    };

    final hasDetail = detail != null && detail.isNotEmpty;
    final tappable = wide || timelineItemRoute(item) != null;

    return ListTile(
      selected: wide && _keyOf(item) == _selectedKey,
      selectedTileColor: scheme.secondaryContainer.withValues(alpha: 0.5),
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Icon(icon, size: 20),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        hasDetail ? '$when  ·  $detail' : when,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: tappable ? () => _openItem(item) : null,
    );
  }
}
