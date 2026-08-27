import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../data/repositories/mood_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/emotion_labels.dart';
import '../timeline/timeline_providers.dart';
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
    ref.invalidate(timelineProvider);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.checkInSaved)));
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/timeline');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkInTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Text(
            l10n.overallMood,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _ScaleSelector(
            value: _mood,
            onChanged: (v) => setState(() => _mood = v),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.emotionsSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          PlutchikWheel(
            selected: _emotions.keys.toSet(),
            onToggle: _toggleEmotion,
            labelFor: l10n.emotionLabel,
          ),
          const SizedBox(height: 8),
          for (final key in _emotions.keys)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 120, child: Text(l10n.emotionLabel(key))),
                  Expanded(
                    child: _ScaleSelector(
                      value: _emotions[key]!,
                      onChanged: (v) => setState(() => _emotions[key] = v),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          TextField(
            controller: _noteController,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: l10n.noteLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
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

/// A compact 1..5 picker shared by overall mood and per-emotion intensity.
class _ScaleSelector extends StatelessWidget {
  const _ScaleSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 1, label: Text('1')),
        ButtonSegment(value: 2, label: Text('2')),
        ButtonSegment(value: 3, label: Text('3')),
        ButtonSegment(value: 4, label: Text('4')),
        ButtonSegment(value: 5, label: Text('5')),
      ],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
