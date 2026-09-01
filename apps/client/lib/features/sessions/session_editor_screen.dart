import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import '../journal/live_markdown_field.dart';
import 'session_links_tab.dart';
import 'session_providers.dart';

class SessionEditorScreen extends ConsumerStatefulWidget {
  const SessionEditorScreen({super.key, this.sessionId, this.onDone});

  final String? sessionId;

  /// When set, the editor is embedded in a pane rather than pushed as a route:
  /// this is called to leave it (after a save, or via the close button) instead
  /// of popping the navigator.
  final VoidCallback? onDone;

  bool get isNew => sessionId == null;

  @override
  ConsumerState<SessionEditorScreen> createState() =>
      _SessionEditorScreenState();
}

class _SessionEditorScreenState extends ConsumerState<SessionEditorScreen> {
  final _agenda = MarkdownStylingController();
  final _notes = MarkdownStylingController();
  final _takeaways = MarkdownStylingController();

  DateTime _scheduledFor = _defaultSlot();
  bool _loading = false;
  bool _saving = false;

  static DateTime _defaultSlot() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 10);
  }

  @override
  void initState() {
    super.initState();
    final id = widget.sessionId;
    if (id != null) {
      _loading = true;
      Future.microtask(() async {
        final session = await ref.read(sessionRepositoryProvider).getById(id);
        if (!mounted) return;
        setState(() {
          if (session != null) {
            _scheduledFor = session.scheduledFor;
            _agenda.text = session.agendaMarkdown ?? '';
            _notes.text = session.notesMarkdown ?? '';
            _takeaways.text = session.takeawaysMarkdown ?? '';
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _agenda.dispose();
    _notes.dispose();
    _takeaways.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledFor,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledFor),
    );
    if (!mounted) return;

    setState(() {
      _scheduledFor = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _scheduledFor.hour,
        time?.minute ?? _scheduledFor.minute,
      );
    });
  }

  Future<void> _insertPreSummary() async {
    final l10n = AppLocalizations.of(context);
    final prev = await ref
        .read(sessionRepositoryProvider)
        .previousBefore(_scheduledFor);
    final from =
        prev?.scheduledFor ?? _scheduledFor.subtract(const Duration(days: 14));
    final markdown = await ref
        .read(exportServiceProvider)
        .buildPreSessionSummary(
          from,
          _scheduledFor,
          emotionLabel: l10n.emotionLabel,
        );
    if (!mounted) return;
    final existing = _agenda.text.trim();
    setState(() {
      _agenda.text = existing.isEmpty
          ? markdown
          : '$markdown\n\n---\n\n$existing';
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.sessionPreSummaryDone)));
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(sessionRepositoryProvider);
    String? textOrNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text;

    if (widget.sessionId == null) {
      await repo.create(
        scheduledFor: _scheduledFor,
        agendaMarkdown: textOrNull(_agenda),
        notesMarkdown: textOrNull(_notes),
        takeawaysMarkdown: textOrNull(_takeaways),
      );
    } else {
      await repo.update(
        id: widget.sessionId!,
        scheduledFor: _scheduledFor,
        agendaMarkdown: textOrNull(_agenda),
        notesMarkdown: textOrNull(_notes),
        takeawaysMarkdown: textOrNull(_takeaways),
      );
    }

    ref.invalidate(sessionListProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).sessionSaved)),
    );
    if (widget.onDone != null) {
      widget.onDone!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/sessions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final showLinks = !widget.isNew;

    return DefaultTabController(
      length: showLinks ? 4 : 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.onDone == null,
          leading: widget.onDone == null
              ? null
              : IconButton(
                  onPressed: widget.onDone,
                  icon: const Icon(Icons.close),
                  tooltip: l10n.cancel,
                ),
          title: Text(widget.isNew ? l10n.newSession : l10n.editSession),
          actions: [
            IconButton(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check),
              tooltip: l10n.saveButton,
            ),
          ],
          bottom: TabBar(
            isScrollable: showLinks,
            tabs: [
              Tab(text: l10n.sessionAgenda),
              Tab(text: l10n.sessionNotes),
              Tab(text: l10n.sessionTakeaways),
              if (showLinks) Tab(text: l10n.sessionLinks),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: OutlinedButton.icon(
                        onPressed: _pickSchedule,
                        icon: const Icon(Icons.event, size: 18),
                        label: Text(
                          '${l10n.sessionScheduledFor}: '
                          '${DateFormat.yMMMd(locale).add_jm().format(_scheduledFor)}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _insertPreSummary,
                    icon: const Icon(
                      Icons.auto_awesome_motion_outlined,
                      size: 18,
                    ),
                    label: Text(l10n.sessionPreSummary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _EditorPane(
                    controller: _agenda,
                    hint: l10n.sessionAgendaHint,
                    l10n: l10n,
                  ),
                  _EditorPane(
                    controller: _notes,
                    hint: l10n.sessionNotesHint,
                    l10n: l10n,
                  ),
                  _EditorPane(
                    controller: _takeaways,
                    hint: l10n.sessionTakeawaysHint,
                    l10n: l10n,
                  ),
                  if (showLinks) SessionLinksTab(sessionId: widget.sessionId!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorPane extends StatelessWidget {
  const _EditorPane({
    required this.controller,
    required this.hint,
    required this.l10n,
  });

  final MarkdownStylingController controller;
  final String hint;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LiveMarkdownField(controller: controller, hintText: hint),
    );
  }
}
