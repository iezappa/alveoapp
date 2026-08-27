import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/local/tables.dart';
import '../../domain/timeline/timeline_item.dart';
import '../../l10n/app_localizations.dart';
import '../export/export_day.dart';
import 'timeline_providers.dart';

/// Route to open for a timeline item, or null if it has no detail screen yet.
String? _routeFor(TimelineItem item) => switch (item) {
      JournalTimelineItem(:final entry) => '/journal/${entry.id}',
      TaskTimelineItem(:final task) => '/tasks/${task.id}',
      SessionTimelineItem(:final session) => '/sessions/${session.id}',
      _ => null,
    };

enum _TimelineMenuAction { newJournal, sessions, tasks, exportDay, settings }

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final timeline = ref.watch(timelineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTimeline),
        actions: [
          PopupMenuButton<_TimelineMenuAction>(
            onSelected: (action) {
              switch (action) {
                case _TimelineMenuAction.newJournal:
                  context.push('/journal/new');
                case _TimelineMenuAction.sessions:
                  context.push('/sessions');
                case _TimelineMenuAction.tasks:
                  context.push('/tasks');
                case _TimelineMenuAction.exportDay:
                  runDailyExport(context, ref);
                case _TimelineMenuAction.settings:
                  context.push('/settings');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _TimelineMenuAction.newJournal,
                child: Text(l10n.journalNewTitle),
              ),
              PopupMenuItem(
                value: _TimelineMenuAction.sessions,
                child: Text(l10n.navSessions),
              ),
              PopupMenuItem(
                value: _TimelineMenuAction.tasks,
                child: Text(l10n.navTasks),
              ),
              PopupMenuItem(
                value: _TimelineMenuAction.exportDay,
                child: Text(l10n.exportDayTooltip),
              ),
              PopupMenuItem(
                value: _TimelineMenuAction.settings,
                child: Text(l10n.navSettings),
              ),
            ],
          ),
        ],
      ),
      body: timeline.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.timelineEmpty));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(timelineProvider),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _TimelineTile(item: items[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/check-in'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addCheckIn),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.item});

  final TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMd(locale).add_Hm().format(item.occurredAt);

    final (IconData icon, String title, String? subtitle) = switch (item) {
      MoodTimelineItem(:final entry) => (
          Icons.favorite_outline,
          l10n.timelineMoodLabel(entry.mood),
          entry.note,
        ),
      JournalTimelineItem(:final entry) => (
          Icons.notes_outlined,
          entry.title ?? l10n.journalUntitled,
          null,
        ),
      TaskTimelineItem(:final task) => (
          Icons.checklist_outlined,
          task.title,
          _taskStatusLabel(l10n, task.status),
        ),
      SessionTimelineItem() => (
          Icons.psychology_outlined,
          l10n.sessionTimelineLabel,
          null,
        ),
    };

    final route = _routeFor(item);
    final hasSubtitle = subtitle != null && subtitle.isNotEmpty;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text([when, if (hasSubtitle) subtitle].join(' · ')),
      isThreeLine: hasSubtitle,
      onTap: route == null ? null : () => context.push(route),
    );
  }

  String _taskStatusLabel(AppLocalizations l10n, TaskStatus status) =>
      switch (status) {
        TaskStatus.pending => l10n.taskStatusPending,
        TaskStatus.inProgress => l10n.taskStatusInProgress,
        TaskStatus.done => l10n.taskStatusDone,
        TaskStatus.skipped => l10n.taskStatusSkipped,
      };
}
