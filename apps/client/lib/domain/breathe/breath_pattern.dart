/// One phase within a single breath cycle.
enum BreathPhase { inhale, holdIn, exhale, holdOut }

/// The state of a paced breathing exercise at a given instant: which [phase]
/// is active, how many whole seconds remain in it (1..phase length), and how
/// far through the phase we are (0..1).
typedef BreathTick = ({
  BreathPhase phase,
  int secondsLeft,
  double phaseProgress,
});

/// A paced breathing pattern measured in whole seconds per phase.
///
/// A phase of length 0 is skipped entirely, so a plain inhale/exhale pattern
/// sets [holdIn] and [holdOut] to 0.
class BreathPattern {
  const BreathPattern({
    required this.inhale,
    required this.holdIn,
    required this.exhale,
    required this.holdOut,
  }) : assert(inhale > 0 && exhale > 0, 'inhale and exhale must be positive');

  final int inhale;
  final int holdIn;
  final int exhale;
  final int holdOut;

  /// Box breathing: equal 4-second inhale, hold, exhale, hold.
  static const box = BreathPattern(inhale: 4, holdIn: 4, exhale: 4, holdOut: 4);

  /// Calming 4-7-8 breathing: no hold after the exhale.
  static const relaxing = BreathPattern(
    inhale: 4,
    holdIn: 7,
    exhale: 8,
    holdOut: 0,
  );

  /// Length of one full cycle.
  Duration get cycle =>
      Duration(seconds: inhale + holdIn + exhale + holdOut);

  List<(BreathPhase, int)> get _segments => [
    (BreathPhase.inhale, inhale),
    (BreathPhase.holdIn, holdIn),
    (BreathPhase.exhale, exhale),
    (BreathPhase.holdOut, holdOut),
  ].where((s) => s.$2 > 0).toList(growable: false);

  /// Resolves [elapsed] since the start of the exercise to the active phase,
  /// looping over the cycle.
  BreathTick tickAt(Duration elapsed) {
    final cycleSeconds = cycle.inSeconds;
    final t = (elapsed.inMicroseconds / Duration.microsecondsPerSecond) %
        cycleSeconds;

    var start = 0.0;
    for (final (phase, length) in _segments) {
      if (t < start + length) {
        final into = t - start;
        return (
          phase: phase,
          secondsLeft: (length - into).ceil().clamp(1, length),
          phaseProgress: into / length,
        );
      }
      start += length;
    }
    // Floating-point fallthrough at exactly t == cycleSeconds.
    final (phase, _) = _segments.last;
    return (phase: phase, secondsLeft: 1, phaseProgress: 1);
  }

  @override
  bool operator ==(Object other) =>
      other is BreathPattern &&
      other.inhale == inhale &&
      other.holdIn == holdIn &&
      other.exhale == exhale &&
      other.holdOut == holdOut;

  @override
  int get hashCode => Object.hash(inhale, holdIn, exhale, holdOut);
}
