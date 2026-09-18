import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import 'task_providers.dart';
import '../shared/save_failure.dart';

class TaskEditorScreen extends ConsumerStatefulWidget {
  const TaskEditorScreen({super.key, this.taskId, this.onDone});

  final String? taskId;

  /// When set, the editor is embedded in a pane rather than pushed as a route:
  /// this is called to leave it (after a save, or via the close button) instead
  /// of popping the navigator.
  final VoidCallback? onDone;

  bool get isNew => taskId == null;

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _closingNoteController = TextEditingController();

  TaskStatus _status = TaskStatus.pending;
  DateTime? _dueDate;
  Task? _existing;
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.taskId;
    if (id != null) {
      _loading = true;
      Future.microtask(() async {
        final task = await ref.read(taskRepositoryProvider).getById(id);
        if (!mounted) return;
        setState(() {
          _existing = task;
          if (task != null) {
            _titleController.text = task.title;
            _descriptionController.text = task.descriptionMarkdown ?? '';
            _closingNoteController.text = task.closingNote ?? '';
            _status = task.status;
            _dueDate = task.dueDate;
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _closingNoteController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(
        () => _dueDate = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    final repo = ref.read(taskRepositoryProvider);
    final description = _descriptionController.text.trim();
    final closingNote = _closingNoteController.text.trim();

    final saved = await saveOrReport(context, () async {
      if (widget.taskId == null) {
        final id = await repo.create(
          title: title,
          descriptionMarkdown: description.isEmpty ? null : description,
          dueDate: _dueDate,
        );
        if (_status != TaskStatus.pending || closingNote.isNotEmpty) {
          await repo.update(
            id: id,
            title: title,
            descriptionMarkdown: description.isEmpty ? null : description,
            dueDate: _dueDate,
            status: _status,
            closingNote: closingNote.isEmpty ? null : closingNote,
          );
        }
      } else {
        await repo.update(
          id: widget.taskId!,
          title: title,
          descriptionMarkdown: description.isEmpty ? null : description,
          dueDate: _dueDate,
          status: _status,
          closingNote: closingNote.isEmpty ? null : closingNote,
          completedAt: _existing?.completedAt,
        );
      }
    });
    if (!saved) {
      if (mounted) setState(() => _saving = false);
      return;
    }

    ref.invalidate(taskListProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).taskSaved)),
    );
    if (widget.onDone != null) {
      widget.onDone!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/tasks');
    }
  }

  String _statusLabel(AppLocalizations l10n, TaskStatus status) =>
      switch (status) {
        TaskStatus.pending => l10n.taskStatusPending,
        TaskStatus.inProgress => l10n.taskStatusInProgress,
        TaskStatus.done => l10n.taskStatusDone,
        TaskStatus.skipped => l10n.taskStatusSkipped,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.onDone == null,
        leading: widget.onDone == null
            ? null
            : IconButton(
                onPressed: widget.onDone,
                icon: const Icon(Icons.close),
                tooltip: l10n.cancel,
              ),
        title: Text(widget.isNew ? l10n.newTask : l10n.editTask),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            tooltip: l10n.saveButton,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.taskTitleHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: l10n.taskDescriptionHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDueDate,
                  icon: const Icon(Icons.event, size: 18),
                  label: Text(
                    _dueDate == null
                        ? l10n.taskNoDueDate
                        : '${l10n.taskDueDate}: '
                              '${DateFormat.yMMMd(locale).format(_dueDate!)}',
                  ),
                ),
              ),
              if (_dueDate != null)
                IconButton(
                  onPressed: () => setState(() => _dueDate = null),
                  icon: const Icon(Icons.clear),
                  tooltip: l10n.taskClearDueDate,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.taskStatus, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final status in TaskStatus.values)
                ChoiceChip(
                  label: Text(_statusLabel(l10n, status)),
                  selected: _status == status,
                  onSelected: (_) => setState(() => _status = status),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _closingNoteController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.taskClosingNoteHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
