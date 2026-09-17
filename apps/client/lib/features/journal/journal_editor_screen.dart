import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../domain/emotions/emotion_input.dart';
import '../../domain/journal/journal_section.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import '../check_in/plutchik_wheel.dart';
import 'journal_providers.dart';
import 'live_markdown_field.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({
    super.key,
    this.entryId,
    this.section = JournalSection.oneLiner,
    this.isMonthlyReview = false,
    this.reviewMonth,
    this.onDone,
  });

  final String? entryId;
  final JournalSection section;
  final bool isMonthlyReview;
  final DateTime? reviewMonth;

  /// When set, the editor is embedded in a pane rather than pushed as a route:
  /// this is called to leave it (after a save, or via the close button) instead
  /// of popping the navigator.
  final VoidCallback? onDone;

  bool get isNew => entryId == null;

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  static const _defaultIntensity = 3;

  final _titleController = TextEditingController();
  final _bodyController = MarkdownStylingController();
  final Set<String> _emotions = {};

  late JournalSection _section = widget.section;
  late bool _isReview = widget.isMonthlyReview;
  late DateTime _entryDate = _initialDate();
  bool _loading = false;
  bool _saving = false;

  DateTime _initialDate() {
    final m = widget.reviewMonth;
    if (widget.isMonthlyReview && m != null) return DateTime(m.year, m.month);
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
        final repo = ref.read(journalRepositoryProvider);
        final entry = await repo.getById(id);
        final emotions = await repo.emotionsFor(id);
        if (!mounted) return;
        setState(() {
          if (entry != null) {
            _titleController.text = entry.title ?? '';
            _bodyController.text = entry.bodyMarkdown;
            _entryDate = entry.entryDate;
            _section = entry.section;
            _isReview = entry.isMonthlyReview;
            _emotions
              ..clear()
              ..addAll(emotions.map((e) => e.emotionKey));
          }
          _loading = false;
        });
      });
    } else if (widget.isMonthlyReview && widget.reviewMonth != null) {
      final month = DateFormat.yMMMM().format(widget.reviewMonth!);
      _titleController.text = 'Review — $month';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _toggleEmotion(String key) {
    setState(() {
      _emotions.contains(key) ? _emotions.remove(key) : _emotions.add(key);
    });
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
    final emotions = [
      for (final key in _emotions)
        EmotionInput(emotionKey: key, intensity: _defaultIntensity),
    ];

    if (widget.entryId == null) {
      await repo.create(
        bodyMarkdown: body,
        entryDate: _entryDate,
        title: title,
        section: _section,
        isMonthlyReview: _isReview,
        emotions: emotions,
      );
    } else {
      await repo.updateBody(
        id: widget.entryId!,
        bodyMarkdown: body,
        title: title,
      );
      await repo.replaceEmotions(widget.entryId!, emotions);
    }

    ref.invalidate(journalListProvider);
    ref.invalidate(journalSectionEntriesProvider(_section));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).journalSaved)),
    );
    if (widget.onDone != null) {
      widget.onDone!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/journal');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final title = _isReview
        ? l10n.monthlyReview
        : (widget.isNew ? l10n.journalNewTitle : l10n.journalEditTitle);

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
        title: Text(title),
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
            decoration: InputDecoration(hintText: l10n.journalTitleHint),
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
          SizedBox(
            height: 260,
            child: LiveMarkdownField(
              controller: _bodyController,
              hintText: l10n.journalBodyHint,
            ),
          ),
          const SizedBox(height: 24),
          SectionLabel(l10n.emotionsSectionTitle),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: PlutchikWheel(
                    selected: _emotions,
                    onToggle: _toggleEmotion,
                    labelFor: l10n.emotionLabel,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
