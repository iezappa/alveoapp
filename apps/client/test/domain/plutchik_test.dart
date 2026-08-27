import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/domain/emotions/plutchik.dart';

void main() {
  test('catalog has the eight Plutchik primaries with unique keys', () {
    expect(plutchikPrimaryEmotions, hasLength(8));

    final keys = plutchikPrimaryEmotions.map((e) => e.key).toSet();
    expect(keys, hasLength(8));
    expect(keys, {
      'joy',
      'sadness',
      'trust',
      'disgust',
      'fear',
      'anger',
      'surprise',
      'anticipation',
    });
  });

  test('opposites are symmetric and point at real keys', () {
    for (final e in plutchikPrimaryEmotions) {
      final opposite = emotionForKey(e.opposite);
      expect(opposite, isNotNull, reason: '${e.key} -> ${e.opposite}');
      expect(opposite!.opposite, e.key);
    }
  });

  test('lookup helpers', () {
    expect(emotionForKey('joy')!.label, 'Joy');
    expect(emotionForKey('not-an-emotion'), isNull);
    expect(isKnownEmotionKey('anger'), isTrue);
    expect(isKnownEmotionKey('anger '), isFalse);
  });
}
