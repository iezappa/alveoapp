import 'emotions/plutchik.dart';

/// Thrown when a value violates a domain rule before it reaches the database.
class DomainValidationException implements Exception {
  const DomainValidationException(this.message);

  final String message;

  @override
  String toString() => 'DomainValidationException: $message';
}

const int minMoodScale = 1;
const int maxMoodScale = 5;
const int minIntensity = 1;
const int maxIntensity = 5;

/// Overall mood on a 1..5 scale. Returns [value] unchanged when valid.
int validateMoodScale(int value) {
  if (value < minMoodScale || value > maxMoodScale) {
    throw DomainValidationException(
      'mood must be between $minMoodScale and $maxMoodScale, got $value',
    );
  }
  return value;
}

/// Emotion intensity on a 1..5 scale. Returns [value] unchanged when valid.
int validateIntensity(int value) {
  if (value < minIntensity || value > maxIntensity) {
    throw DomainValidationException(
      'intensity must be between $minIntensity and $maxIntensity, got $value',
    );
  }
  return value;
}

/// Returns [key] unchanged when it belongs to the Plutchik catalog.
String validateEmotionKey(String key) {
  if (!isKnownEmotionKey(key)) {
    throw DomainValidationException('unknown emotion key: "$key"');
  }
  return key;
}
