import 'package:flutter/material.dart';

import '../../domain/breathe/breath_pattern.dart';
import '../../l10n/app_localizations.dart';

/// A guided breathing session: a soft focal circle that expands and contracts
/// with the chosen [BreathPattern], the current phase named inside it, and a
/// countdown of the time left in the session.
class BreatheScreen extends StatefulWidget {
  const BreatheScreen({super.key});

  @override
  State<BreatheScreen> createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with SingleTickerProviderStateMixin {
  static const _sessionLength = Duration(minutes: 2);

  late final AnimationController _controller = AnimationController(vsync: this);
  final Stopwatch _stopwatch = Stopwatch();
  BreathPattern _pattern = BreathPattern.box;
  bool _running = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _running = true;
      _stopwatch
        ..reset()
        ..start();
      _controller
        ..duration = _pattern.cycle
        ..repeat();
    });
  }

  void _stop() {
    if (!_running) return;
    setState(() {
      _running = false;
      _stopwatch
        ..stop()
        ..reset();
      _controller
        ..stop()
        ..reset();
    });
  }

  double _scaleFor(BreathTick tick) => switch (tick.phase) {
    BreathPhase.inhale => 0.82 + 0.18 * tick.phaseProgress,
    BreathPhase.holdIn => 1,
    BreathPhase.exhale => 1 - 0.18 * tick.phaseProgress,
    BreathPhase.holdOut => 0.82,
  };

  String _phaseLabel(AppLocalizations l10n, BreathPhase phase) =>
      switch (phase) {
        BreathPhase.inhale => l10n.breathePhaseInhale,
        BreathPhase.holdIn => l10n.breathePhaseHold,
        BreathPhase.exhale => l10n.breathePhaseExhale,
        BreathPhase.holdOut => l10n.breathePhaseHold,
      };

  static String _clock(Duration d) {
    final total = d.inSeconds < 0 ? 0 : d.inSeconds;
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.breatheTitle)),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.1,
            colors: [
              Color.alphaBlend(
                scheme.primary.withValues(alpha: 0.07),
                scheme.surface,
              ),
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final remaining = _sessionLength - _stopwatch.elapsed;
                  if (_running && remaining <= Duration.zero) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _stop(),
                    );
                  }
                  final tick = _pattern.tickAt(
                    _running
                        ? _pattern.cycle * _controller.value
                        : Duration.zero,
                  );
                  return _FocalCircle(
                    label: _phaseLabel(l10n, tick.phase),
                    scale: _running ? _scaleFor(tick) : 0.9,
                  );
                },
              ),
              const Spacer(flex: 2),
              if (_running)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final remaining = _sessionLength - _stopwatch.elapsed;
                    return Column(
                      children: [
                        Text(
                          _clock(remaining),
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.breatheRemaining.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 2,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                )
              else
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
                      setState(() => _pattern = selection.first),
                ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _running ? _stop : _start,
                    child: Text(
                      _running ? l10n.breatheStop : l10n.breatheStart,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocalCircle extends StatelessWidget {
  const _FocalCircle({required this.label, required this.scale});

  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final light = theme.brightness == Brightness.light;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
      width: 210 * scale,
      height: 210 * scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: light ? Colors.white : scheme.surfaceContainerHigh,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: light ? 0.06 : 0.28),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        label,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
