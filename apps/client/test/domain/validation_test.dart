import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/validation.dart';

void main() {
  group('mood scale', () {
    test('accepts 1..5 unchanged', () {
      for (var v = 1; v <= 5; v++) {
        expect(validateMoodScale(v), v);
      }
    });

    test('rejects values outside 1..5', () {
      expect(
        () => validateMoodScale(0),
        throwsA(isA<DomainValidationException>()),
      );
      expect(
        () => validateMoodScale(6),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });

  group('intensity', () {
    test('accepts 1..5 unchanged', () {
      for (var v = 1; v <= 5; v++) {
        expect(validateIntensity(v), v);
      }
    });

    test('rejects values outside 1..5', () {
      expect(
        () => validateIntensity(0),
        throwsA(isA<DomainValidationException>()),
      );
      expect(
        () => validateIntensity(9),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });

  group('emotion key', () {
    test('accepts a catalog key', () {
      expect(validateEmotionKey('trust'), 'trust');
    });

    test('rejects an unknown key', () {
      expect(
        () => validateEmotionKey('vibes'),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });
}
