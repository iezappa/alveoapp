import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/local/tables.dart';
import '../../domain/timeline/timeline_item.dart';
import '../../l10n/app_localizations.dart';
import 'timeline_providers.dart';

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
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.navSettings,
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
    };

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text([when, if (subtitle != null && subtitle.isNotEmpty) subtitle].join(' · ')),
      isThreeLine: subtitle != null && subtitle.isNotEmpty,
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
