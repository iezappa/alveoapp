import 'emotion.dart';

/// Plutchik's eight primary emotions, arranged in opposing pairs.
///
/// The wheel's finer gradations (serenity/ecstasy around joy, etc.) and the
/// dyads (love = joy + trust) are layered on top of these later; Fase 1 only
/// needs the eight anchors.
const List<Emotion> plutchikPrimaryEmotions = [
  Emotion(key: 'joy', label: 'Joy', opposite: 'sadness'),
  Emotion(key: 'sadness', label: 'Sadness', opposite: 'joy'),
  Emotion(key: 'trust', label: 'Trust', opposite: 'disgust'),
  Emotion(key: 'disgust', label: 'Disgust', opposite: 'trust'),
  Emotion(key: 'fear', label: 'Fear', opposite: 'anger'),
  Emotion(key: 'anger', label: 'Anger', opposite: 'fear'),
  Emotion(key: 'surprise', label: 'Surprise', opposite: 'anticipation'),
  Emotion(key: 'anticipation', label: 'Anticipation', opposite: 'surprise'),
];

final Map<String, Emotion> _byKey = {
  for (final e in plutchikPrimaryEmotions) e.key: e,
};

/// Returns the emotion for [key], or null if it is not part of the catalog.
Emotion? emotionForKey(String key) => _byKey[key];

bool isKnownEmotionKey(String key) => _byKey.containsKey(key);
