import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../domain/cbt/cognitive_distortion.dart';
import '../../l10n/app_localizations.dart';
import 'cbt_labels.dart';
import 'thought_record_providers.dart';
import '../shared/save_failure.dart';

/// The guided thought-record form: situation → automatic thought → belief →
/// emotion → distortions → alternative thought → re-rating.
class ThoughtRecordEditorScreen extends ConsumerStatefulWidget {
  const ThoughtRecordEditorScreen({super.key, this.recordId, this.onDone});

  final String? recordId;

  /// When set, the editor is embedded in a pane; called to leave it instead of
  /// popping the navigator.
  final VoidCallback? onDone;

  bool get isNew => recordId == null;

  @override
  ConsumerState<ThoughtRecordEditorScreen> createState() =>
      _ThoughtRecordEditorScreenState();
}

class _ThoughtRecordEditorScreenState
    extends ConsumerState<ThoughtRecordEditorScreen> {
  final _situation = TextEditingController();
  final _automatic = TextEditingController();
  final _emotion = TextEditingController();
  final _alternative = TextEditingController();
  final _distortions = <CognitiveDistortion>{};

  DateTime _occurredAt = DateTime.now();
  double _beliefBefore = 50;
  double _beliefAfter = 50;
  double _intensityBefore = 5;
  double _intensityAfter = 5;
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.recordId;
    if (id != null) {
      _loading = true;
      Future.microtask(() async {
        final repo = ref.read(thoughtRecordRepositoryProvider);
        final record = await repo.getById(id);
        final distortions = await repo.distortionsFor(id);
        if (!mounted) return;
        setState(() {
          if (record != null) {
            _occurredAt = record.occurredAt;
            _situation.text = record.situation;
            _automatic.text = record.automaticThought;
            _emotion.text = record.emotionLabel ?? '';
            _alternative.text = record.alternativeThought ?? '';
            _beliefBefore = (record.beliefBefore ?? 50).toDouble();
            _beliefAfter = (record.beliefAfter ?? 50).toDouble();
            _intensityBefore = (record.emotionIntensityBefore ?? 5).toDouble();
            _intensityAfter = (record.emotionIntensityAfter ?? 5).toDouble();
            _distortions
              ..clear()
              ..addAll(distortions);
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _situation.dispose();
    _automatic.dispose();
    _emotion.dispose();
    _alternative.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _occurredAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _occurredAt.hour,
          _occurredAt.minute,
        );
      });
    }
  }

  Future<void> _save() async {
    if (_situation.text.trim().isEmpty || _automatic.text.trim().isEmpty) {
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(thoughtRecordRepositoryProvider);
    String? textOrNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    final saved = await saveOrReport(context, () async {
      if (widget.recordId == null) {
        await repo.create(
          occurredAt: _occurredAt,
          situation: _situation.text.trim(),
          automaticThought: _automatic.text.trim(),
          beliefBefore: _beliefBefore.round(),
          emotionLabel: textOrNull(_emotion),
          emotionIntensityBefore: _intensityBefore.round(),
          distortions: _distortions,
          alternativeThought: textOrNull(_alternative),
          beliefAfter: _beliefAfter.round(),
          emotionIntensityAfter: _intensityAfter.round(),
        );
      } else {
        await repo.update(
          id: widget.recordId!,
          occurredAt: _occurredAt,
          situation: _situation.text.trim(),
          automaticThought: _automatic.text.trim(),
          beliefBefore: _beliefBefore.round(),
          emotionLabel: textOrNull(_emotion),
          emotionIntensityBefore: _intensityBefore.round(),
          distortions: _distortions,
          alternativeThought: textOrNull(_alternative),
          beliefAfter: _beliefAfter.round(),
          emotionIntensityAfter: _intensityAfter.round(),
        );
      }
    });
    if (!saved) {
      if (mounted) setState(() => _saving = false);
      return;
    }

    ref.invalidate(thoughtRecordListProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).thoughtRecordSaved)),
    );
    if (widget.onDone != null) {
      widget.onDone!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/tools');
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
        automaticallyImplyLeading: widget.onDone == null,
        leading: widget.onDone == null
            ? null
            : IconButton(
                onPressed: widget.onDone,
                icon: const Icon(Icons.close),
                tooltip: l10n.cancel,
              ),
        title: Text(
          widget.isNew ? l10n.newThoughtRecord : l10n.editThoughtRecord,
        ),
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
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event, size: 18),
              label: Text(DateFormat.yMMMd(locale).format(_occurredAt)),
            ),
          ),
          const SizedBox(height: 20),
          _field(l10n.trSituation, _situation, l10n.trSituationHint),
          const SizedBox(height: 20),
          _field(
            l10n.trAutomaticThought,
            _automatic,
            l10n.trAutomaticThoughtHint,
          ),
          const SizedBox(height: 20),
          _slider(
            l10n.trBeliefBefore,
            _beliefBefore,
            0,
            100,
            (v) => setState(() => _beliefBefore = v),
            suffix: '%',
          ),
          const SizedBox(height: 12),
          SectionLabel(l10n.trEmotion),
          const SizedBox(height: 6),
          TextField(
            controller: _emotion,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l10n.trEmotionHint),
          ),
          const SizedBox(height: 12),
          _slider(
            l10n.trEmotionIntensityBefore,
            _intensityBefore,
            0,
            10,
            (v) => setState(() => _intensityBefore = v),
          ),
          const SizedBox(height: 20),
          SectionLabel(l10n.trDistortions),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final d in CognitiveDistortion.values)
                FilterChip(
                  label: Text(d.label(l10n)),
                  selected: _distortions.contains(d),
                  onSelected: (on) => setState(() {
                    on ? _distortions.add(d) : _distortions.remove(d);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _field(
            l10n.trAlternativeThought,
            _alternative,
            l10n.trAlternativeThoughtHint,
          ),
          const SizedBox(height: 20),
          _slider(
            l10n.trBeliefAfter,
            _beliefAfter,
            0,
            100,
            (v) => setState(() => _beliefAfter = v),
            suffix: '%',
          ),
          const SizedBox(height: 12),
          _slider(
            l10n.trEmotionIntensityAfter,
            _intensityAfter,
            0,
            10,
            (v) => setState(() => _intensityAfter = v),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, String hint) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionLabel(label),
      const SizedBox(height: 6),
      TextField(
        controller: c,
        minLines: 2,
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    String suffix = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [SectionLabel(label), Text('${value.round()}$suffix')],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          label: '${value.round()}$suffix',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
