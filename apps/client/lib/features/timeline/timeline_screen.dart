import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
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
          IconButton(
            icon: const Icon(Icons.note_add_outlined),
            onPressed: () => context.push('/journal/new'),
            tooltip: l10n.journalNewTitle,
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
      ),
      body: timeline.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.timeline_outlined,
              message: l10n.timelineEmpty,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(timelineProvider),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 2),
                  itemBuilder: (context, i) => _TimelineTile(item: items[i]),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
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
    final hasDetail = detail != null && detail.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kGutter),
      child: ListTile(
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
        trailing: route == null
            ? null
            : const Icon(Icons.chevron_right, size: 20),
        onTap: route == null ? null : () => context.push(route),
      ),
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
