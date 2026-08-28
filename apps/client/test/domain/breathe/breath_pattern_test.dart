import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/domain/breathe/breath_pattern.dart';

void main() {
  group('box breathing', () {
    const pattern = BreathPattern.box;

    test('a full cycle is 16 seconds', () {
      expect(pattern.cycle, const Duration(seconds: 16));
    });

    test('walks inhale -> hold -> exhale -> hold across the cycle', () {
      expect(pattern.tickAt(Duration.zero).phase, BreathPhase.inhale);
      expect(pattern.tickAt(const Duration(seconds: 4)).phase, BreathPhase.holdIn);
      expect(pattern.tickAt(const Duration(seconds: 8)).phase, BreathPhase.exhale);
      expect(
        pattern.tickAt(const Duration(seconds: 12)).phase,
        BreathPhase.holdOut,
      );
    });

    test('loops back to inhale after one full cycle', () {
      expect(pattern.tickAt(const Duration(seconds: 16)).phase, BreathPhase.inhale);
    });

    test('reports remaining seconds and progress within a phase', () {
      final tick = pattern.tickAt(const Duration(seconds: 2));
      expect(tick.phase, BreathPhase.inhale);
      expect(tick.secondsLeft, 2);
      expect(tick.phaseProgress, closeTo(0.5, 1e-9));
    });
  });

  group('4-7-8 breathing', () {
    const pattern = BreathPattern.relaxing;

    test('skips the zero-length hold after the exhale', () {
      // Cycle is 4 + 7 + 8 = 19s; second 18 is still the exhale.
      expect(pattern.tickAt(const Duration(seconds: 18)).phase, BreathPhase.exhale);
      // Second 19 wraps straight back to the inhale, never holdOut.
      expect(pattern.tickAt(const Duration(seconds: 19)).phase, BreathPhase.inhale);
    });
  });

  test('const patterns compare by value', () {
    expect(
      const BreathPattern(inhale: 4, holdIn: 4, exhale: 4, holdOut: 4),
      BreathPattern.box,
    );
    expect(BreathPattern.box == BreathPattern.relaxing, isFalse);
  });
}
