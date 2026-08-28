import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../data/repositories/mood_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import 'plutchik_wheel.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  static const _defaultIntensity = 3;

  int _mood = 3;
  final Map<String, int> _emotions = {};
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
    await ref
        .read(moodRepositoryProvider)
        .add(
          mood: _mood,
          occurredAt: DateTime.now(),
          note: note.isEmpty ? null : note,
          emotions: [
            for (final entry in _emotions.entries)
              EmotionInput(emotionKey: entry.key, intensity: entry.value),
          ],
        );

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.checkInSaved)));
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkInTitle)),
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

/// Five colour-graded dots for the overall 1..5 mood, with a caption for the
/// current value.
class _MoodScale extends StatelessWidget {
  const _MoodScale({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  static const _low = Color(0xFFC97B63); // muted terracotta
  static const _mid = Color(0xFFBDBDB2); // warm grey
  static const _high = Color(0xFF5E8B7E); // sage

  Color _colorFor(int v) {
    final t = (v - 1) / 4;
    return t < 0.5
        ? Color.lerp(_low, _mid, t * 2)!
        : Color.lerp(_mid, _high, (t - 0.5) * 2)!;
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var v = 1; v <= 5; v++)
              GestureDetector(
                key: Key('mood-$v'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: v == value
                        ? _colorFor(v)
                        : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: Border.all(
                      color: v == value ? _colorFor(v) : scheme.outlineVariant,
                      width: v == value ? 2 : 1,
                    ),
                  ),
                  child: v == value
                      ? const Icon(Icons.check, size: 20, color: Colors.white)
                      : null,
                ),
              ),
          ],
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
