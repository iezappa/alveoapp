import 'emotion.dart';

/// Plutchik's eight primary emotions, arranged in opposing pairs.
///
/// The wheel's finer gradations (serenity/ecstasy around joy, etc.) and the
/// dyads (love = joy + trust) are layered on top of these later; Fase 1 only
/// needs the eight anchors. Display labels come from the localizations, keyed
/// by [Emotion.key].
const List<Emotion> plutchikPrimaryEmotions = [
  Emotion(key: 'joy', opposite: 'sadness'),
  Emotion(key: 'sadness', opposite: 'joy'),
  Emotion(key: 'trust', opposite: 'disgust'),
  Emotion(key: 'disgust', opposite: 'trust'),
  Emotion(key: 'fear', opposite: 'anger'),
  Emotion(key: 'anger', opposite: 'fear'),
  Emotion(key: 'surprise', opposite: 'anticipation'),
  Emotion(key: 'anticipation', opposite: 'surprise'),
];

final Map<String, Emotion> _byKey = {
  for (final e in plutchikPrimaryEmotions) e.key: e,
};

/// Returns the emotion for [key], or null if it is not part of the catalog.
Emotion? emotionForKey(String key) => _byKey[key];

bool isKnownEmotionKey(String key) => _byKey.containsKey(key);
