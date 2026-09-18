import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../domain/emotions/emotion_input.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import '../shared/confirm_delete.dart';
import 'mood_weather.dart';
import 'plutchik_wheel.dart';
import '../shared/save_failure.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key, this.moodEntryId});

  final String? moodEntryId;

  bool get isNew => moodEntryId == null;

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  static const _defaultIntensity = 3;

  int _mood = 3;
  final Map<String, int> _emotions = {};
  final _noteController = TextEditingController();
  final _tagController = TextEditingController();
  final Set<String> _tags = {};
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.moodEntryId;
    if (id != null) {
      _loading = true;
      Future.microtask(() async {
        final repo = ref.read(moodRepositoryProvider);
        final entry = await repo.getById(id);
        final emotions = await repo.emotionsFor(id);
        final tags = await repo.tagsFor(id);
        if (!mounted) return;
        setState(() {
          if (entry != null) {
            _mood = entry.mood;
            _noteController.text = entry.note ?? '';
            _emotions
              ..clear()
              ..addEntries(
                emotions.map((e) => MapEntry(e.emotionKey, e.intensity)),
              );
            _tags
              ..clear()
              ..addAll(tags.map((t) => t.name));
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return;
    setState(() {
      _tags.add(name);
      _tagController.clear();
    });
  }

  void _toggleEmotion(String key) {
    setState(() {
      if (_emotions.containsKey(key)) {
        _emotions.remove(key);
      } else {
        _emotions[key] = _defaultIntensity;
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final note = _noteController.text.trim();
    final emotions = [
      for (final entry in _emotions.entries)
        EmotionInput(emotionKey: entry.key, intensity: entry.value),
    ];
    final repo = ref.read(moodRepositoryProvider);
    final tagRepo = ref.read(tagRepositoryProvider);
    final saved = await saveOrReport(context, () async {
      final tagIds = [
        for (final name in _tags) await tagRepo.findOrCreate(name),
      ];

      if (widget.moodEntryId == null) {
        await repo.add(
          mood: _mood,
          occurredAt: DateTime.now(),
          note: note.isEmpty ? null : note,
          emotions: emotions,
          tagIds: tagIds,
        );
      } else {
        await repo.update(
          id: widget.moodEntryId!,
          mood: _mood,
          note: note.isEmpty ? null : note,
          emotions: emotions,
          tagIds: tagIds,
        );
      }
    });
    if (!saved) {
      if (mounted) setState(() => _saving = false);
      return;
    }

    ref.invalidate(moodEntriesProvider);
    ref.invalidate(allTagsProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).checkInSaved)),
    );
    _leave();
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context) || !mounted) return;
    final deleted = await deleteOrReport(
      context,
      () => ref.read(moodRepositoryProvider).delete(widget.moodEntryId!),
    );
    if (!deleted) return;
    ref.invalidate(moodEntriesProvider);
    if (mounted) _leave();
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? l10n.checkInTitle : l10n.checkInEditTitle),
        actions: [
          if (!widget.isNew)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.deleteAction,
            ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(kGutter, kGutter, kGutter, 112),
            children: [
              SectionLabel(l10n.overallMood),
              const SizedBox(height: 4),
              _MoodScale(
                value: _mood,
                onChanged: (v) => setState(() => _mood = v),
              ),
              const SizedBox(height: 32),

              SectionLabel(l10n.emotionsSectionTitle),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: PlutchikWheel(
                        selected: _emotions.keys.toSet(),
                        onToggle: _toggleEmotion,
                        labelFor: l10n.emotionLabel,
                      ),
                    ),
                  ),
                ),
              ),
              if (_emotions.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final key in _emotions.keys)
                  _EmotionRow(
                    label: l10n.emotionLabel(key),
                    intensity: _emotions[key]!,
                    onIntensity: (v) => setState(() => _emotions[key] = v),
                    onRemove: () => setState(() => _emotions.remove(key)),
                  ),
              ],
              const SizedBox(height: 32),

              SectionLabel(l10n.noteLabel),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: l10n.noteLabel),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),

              SectionLabel(l10n.tagsLabel),
              const SizedBox(height: 8),
              _TagEditor(
                selected: _tags,
                controller: _tagController,
                onAdd: _addTag,
                onRemove: (t) => setState(() => _tags.remove(t)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(l10n.saveButton),
      ),
    );
  }
}

/// Free-text tag input: chips for the chosen tags, a field to add one, and
/// quick chips for tags used before.
class _TagEditor extends ConsumerWidget {
  const _TagEditor({
    required this.selected,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
  });

  final Set<String> selected;
  final TextEditingController controller;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(allTagsProvider).asData?.value ?? const [];
    final lower = selected.map((s) => s.toLowerCase()).toSet();
    final suggestions = [
      for (final t in all)
        if (!lower.contains(t.name.toLowerCase())) t.name,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selected.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in selected)
                InputChip(label: Text(t), onDeleted: () => onRemove(t)),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          onSubmitted: onAdd,
          decoration: InputDecoration(
            hintText: l10n.tagsHint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onAdd(controller.text),
            ),
          ),
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final s in suggestions.take(12))
                ActionChip(label: Text(s), onPressed: () => onAdd(s)),
            ],
          ),
        ],
      ],
    );
  }
}

/// Five colour-graded dots for the overall 1..5 mood, with a caption for the
/// current value.
class _MoodScale extends StatelessWidget {
  const _MoodScale({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  String _caption(AppLocalizations l10n) => switch (value) {
    1 => l10n.moodScale1,
    2 => l10n.moodScale2,
    3 => l10n.moodScale3,
    4 => l10n.moodScale4,
    _ => l10n.moodScale5,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var v = 1; v <= 5; v++)
                GestureDetector(
                  key: Key('mood-$v'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: v == value ? scheme.surface : Colors.transparent,
                      boxShadow: v == value
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Opacity(
                      opacity: v == value ? 1 : 0.55,
                      child: Text(
                        moodWeather[v - 1],
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            _caption(AppLocalizations.of(context)),
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _EmotionRow extends StatelessWidget {
  const _EmotionRow({
    required this.label,
    required this.intensity,
    required this.onIntensity,
    required this.onRemove,
  });

  final String label;
  final int intensity;
  final ValueChanged<int> onIntensity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          _IntensityDots(value: intensity, onChanged: onIntensity),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close, size: 18),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

/// Five small dots; tap the nth to set intensity to n.
class _IntensityDots extends StatelessWidget {
  const _IntensityDots({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var v = 1; v <= 5; v++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(v),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: v <= value
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
