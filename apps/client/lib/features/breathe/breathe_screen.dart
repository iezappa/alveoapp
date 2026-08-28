import 'package:flutter/material.dart';

import '../../domain/breathe/breath_pattern.dart';
import '../../l10n/app_localizations.dart';

/// A guided breathing exercise: an expanding/contracting circle paced by a
/// [BreathPattern], with a phase label and a per-phase countdown.
class BreatheScreen extends StatefulWidget {
  const BreatheScreen({super.key});

  @override
  State<BreatheScreen> createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  BreathPattern _pattern = BreathPattern.box;
  bool _running = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _running = !_running;
      if (_running) {
        _controller
          ..duration = _pattern.cycle
          ..repeat();
      } else {
        _controller
          ..stop()
          ..reset();
      }
    });
  }

  void _selectPattern(BreathPattern pattern) {
    setState(() {
      _pattern = pattern;
      if (_running) {
        _controller
          ..duration = pattern.cycle
          ..repeat();
      }
    });
  }

  double _scaleFor(BreathTick tick) => switch (tick.phase) {
    BreathPhase.inhale => 0.5 + 0.5 * tick.phaseProgress,
    BreathPhase.holdIn => 1,
    BreathPhase.exhale => 1 - 0.5 * tick.phaseProgress,
    BreathPhase.holdOut => 0.5,
  };

  String _phaseLabel(AppLocalizations l10n, BreathPhase phase) =>
      switch (phase) {
        BreathPhase.inhale => l10n.breathePhaseInhale,
        BreathPhase.holdIn => l10n.breathePhaseHold,
        BreathPhase.exhale => l10n.breathePhaseExhale,
        BreathPhase.holdOut => l10n.breathePhaseHold,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.breatheTitle)),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            SegmentedButton<BreathPattern>(
              segments: [
                ButtonSegment(
                  value: BreathPattern.box,
                  label: Text(l10n.breathePatternBox),
                ),
                ButtonSegment(
                  value: BreathPattern.relaxing,
                  label: Text(l10n.breathePatternRelaxing),
                ),
              ],
              selected: {_pattern},
              onSelectionChanged: (selection) =>
                  _selectPattern(selection.first),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final tick = _pattern.tickAt(
                  _running ? _pattern.cycle * _controller.value : Duration.zero,
                );
                return Column(
                  children: [
                    SizedBox(
                      height: 260,
                      width: 260,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: 220 * _scaleFor(tick),
                          height: 220 * _scaleFor(tick),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.secondaryContainer,
                            border: Border.all(
                              color: scheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _running
                          ? _phaseLabel(l10n, tick.phase)
                          : l10n.breatheReady,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _running ? '${tick.secondsLeft}' : '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: _toggle,
                child: Text(
                  _running ? l10n.breatheStop : l10n.breatheStart,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
