import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../timeline/timeline_providers.dart';
import 'journal_providers.dart';
import 'markdown_editor.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.entryId});

  final String? entryId;

  bool get isNew => entryId == null;

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  DateTime _entryDate = _today();
  bool _loading = false;
  bool _saving = false;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    final id = widget.entryId;
    if (id != null) {
      _loading = true;
      Future.microtask(() async {
        final entry = await ref.read(journalRepositoryProvider).getById(id);
        if (!mounted) return;
        setState(() {
          if (entry != null) {
            _titleController.text = entry.title ?? '';
            _bodyController.text = entry.bodyMarkdown;
            _entryDate = entry.entryDate;
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(
        () => _entryDate = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _save() async {
    final body = _bodyController.text;
    if (body.trim().isEmpty) return;

    setState(() => _saving = true);
    final repo = ref.read(journalRepositoryProvider);
    final rawTitle = _titleController.text.trim();
    final title = rawTitle.isEmpty ? null : rawTitle;

    if (widget.entryId == null) {
      await repo.create(
        bodyMarkdown: body,
        entryDate: _entryDate,
        title: title,
      );
    } else {
      await repo.updateBody(
        id: widget.entryId!,
        bodyMarkdown: body,
        title: title,
      );
    }

    ref.invalidate(journalListProvider);
    ref.invalidate(timelineProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).journalSaved)),
    );
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/timeline');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isNew ? l10n.journalNewTitle : l10n.journalEditTitle,
        ),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            tooltip: l10n.saveButton,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.journalTitleHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  '${l10n.journalDate}: '
                  '${DateFormat.yMMMd(locale).format(_entryDate)}',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: MarkdownEditor(
                controller: _bodyController,
                writeLabel: l10n.editorWrite,
                previewLabel: l10n.editorPreview,
                hintText: l10n.journalBodyHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
