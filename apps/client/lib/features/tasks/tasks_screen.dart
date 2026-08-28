import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../shared/confirm_delete.dart';
import '../shared/master_detail_shell.dart';
import 'task_editor_screen.dart';
import 'task_preview.dart';
import 'task_providers.dart';

/// Tasks as a master-detail screen: the task list on the left, a read-only
/// preview of the selected one on the right (wide windows only).
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final _search = TextEditingController();
  final _statuses = <TaskStatus>{};
  String? _selectedId;
  bool _creating = false;
  bool _editingSelected = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(String id) {
    if (MasterDetailShell.isWide(context)) {
      setState(() {
        _selectedId = id;
        _creating = false;
        _editingSelected = false;
      });
    } else {
      context.push('/tasks/$id');
    }
  }

  void _add() {
    if (MasterDetailShell.isWide(context)) {
      setState(() {
        _creating = true;
        _editingSelected = false;
      });
    } else {
      context.push('/tasks/new');
    }
  }

  void _exitEditor() {
    if (mounted) {
      setState(() {
        _creating = false;
        _editingSelected = false;
      });
    }
  }

  Future<void> _delete(String id) async {
    if (!await confirmDelete(context)) return;
    await ref.read(taskRepositoryProvider).delete(id);
    ref.invalidate(taskListProvider);
    if (mounted) setState(() => _selectedId = null);
  }

  List<Task> _filter(List<Task> all) {
    final query = _search.text.trim().toLowerCase();
    return all.where((t) {
      if (_statuses.isNotEmpty && !_statuses.contains(t.status)) return false;
      if (query.isEmpty) return true;
      return t.title.toLowerCase().contains(query) ||
          (t.descriptionMarkdown ?? '').toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MasterDetailShell.isWide(context);
    final tasks = ref.watch(taskListProvider);

    final list = RecordListPane(
      searchController: _search,
      onSearchChanged: (_) => setState(() {}),
      searchHint: l10n.tasksSearchHint,
      addTooltip: l10n.newTask,
      onAdd: _add,
      filters: [
        for (final status in TaskStatus.values)
          FilterChip(
            label: Text(TaskPreview.statusLabel(l10n, status)),
            selected: _statuses.contains(status),
            onSelected: (on) => setState(() {
              on ? _statuses.add(status) : _statuses.remove(status);
            }),
          ),
      ],
      child: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final items = _filter(all);
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.checklist_outlined,
              message: l10n.tasksEmpty,
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
    if (_creating) {
      detail = TaskEditorScreen(
        key: const ValueKey('task-editor-new'),
        onDone: _exitEditor,
      );
    } else if (_editingSelected && _selectedId != null) {
      detail = TaskEditorScreen(
        key: ValueKey('task-editor-$_selectedId'),
        taskId: _selectedId,
        onDone: _exitEditor,
      );
    } else if (_selectedId != null) {
      detail = TaskPreview(
        key: ValueKey(_selectedId),
        taskId: _selectedId!,
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
      title: l10n.navTasks,
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

  Widget _tile(Task task, bool wide) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final isDone = task.status == TaskStatus.done;

    final parts = <String>[
      TaskPreview.statusLabel(AppLocalizations.of(context), task.status),
      if (task.dueDate != null) DateFormat.MMMd(locale).format(task.dueDate!),
    ];

    return ListTile(
      selected: wide && task.id == _selectedId,
      selectedTileColor: theme.colorScheme.secondaryContainer.withValues(
        alpha: 0.5,
      ),
      leading: Checkbox(
        value: isDone,
        onChanged: (checked) async {
          await ref
              .read(taskRepositoryProvider)
              .setStatus(
                task.id,
                (checked ?? false) ? TaskStatus.done : TaskStatus.pending,
              );
          ref.invalidate(taskListProvider);
        },
      ),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurfaceVariant,
              )
            : null,
      ),
      subtitle: Text(parts.join('  ·  ')),
      onTap: () => _open(task.id),
    );
  }
}
