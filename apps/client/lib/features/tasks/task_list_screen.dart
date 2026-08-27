import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(title: Text(l10n.navTasks)),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.tasksEmpty));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(taskListProvider),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _TaskTile(task: items[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      if (task.dueDate != null)
        DateFormat.yMMMd(locale).format(task.dueDate!),
    ];

    return ListTile(
      leading: Checkbox(
        value: _isDone,
        onChanged: (checked) async {
          await ref.read(taskRepositoryProvider).setStatus(
                task.id,
                (checked ?? false) ? TaskStatus.done : TaskStatus.pending,
              );
          ref.invalidate(taskListProvider);
          ref.invalidate(timelineProvider);
        },
      ),
      title: Text(
        task.title,
        style: _isDone
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text(parts.join(' · ')),
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
