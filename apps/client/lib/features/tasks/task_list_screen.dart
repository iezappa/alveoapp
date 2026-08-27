import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../timeline/timeline_providers.dart';
import 'task_providers.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tasks = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.navSettings,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.checklist_outlined,
              message: l10n.tasksEmpty,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(taskListProvider),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kGutter,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 2),
                  itemBuilder: (context, i) => _TaskTile(task: items[i]),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/tasks/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.newTask),
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  bool get _isDone => task.status == TaskStatus.done;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    final parts = <String>[
      _statusLabel(l10n, task.status),
      if (task.dueDate != null) DateFormat.MMMd(locale).format(task.dueDate!),
    ];

    return ListTile(
      leading: Checkbox(
        value: _isDone,
        onChanged: (checked) async {
          await ref
              .read(taskRepositoryProvider)
              .setStatus(
                task.id,
                (checked ?? false) ? TaskStatus.done : TaskStatus.pending,
              );
          ref.invalidate(taskListProvider);
          ref.invalidate(timelineProvider);
        },
      ),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : null,
      ),
      subtitle: Text(parts.join('  ·  ')),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push('/tasks/${task.id}'),
    );
  }

  String _statusLabel(AppLocalizations l10n, TaskStatus status) =>
      switch (status) {
        TaskStatus.pending => l10n.taskStatusPending,
        TaskStatus.inProgress => l10n.taskStatusInProgress,
        TaskStatus.done => l10n.taskStatusDone,
        TaskStatus.skipped => l10n.taskStatusSkipped,
      };
}
