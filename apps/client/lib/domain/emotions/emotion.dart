/// A primary emotion from Plutchik's wheel.
class Emotion {
  const Emotion({
    required this.key,
    required this.label,
    required this.opposite,
  });

  /// Stable identifier persisted in the database. NEVER localize this.
  final String key;

  /// Human-readable name.
  ///
  /// Placeholder English. The UI language / i18n strategy is still an open
  /// decision — when it lands, labels move to ARB files keyed by [key].
  final String label;

  /// [key] of the diametrically opposite emotion on the wheel.
  final String opposite;
}
