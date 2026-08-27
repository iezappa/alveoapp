/// A primary emotion from Plutchik's wheel.
///
/// The model carries no display text: labels are resolved at the presentation
/// layer from [key] via the localizations (see `l10n/emotion_labels.dart`), so
/// the same catalog serves every language.
class Emotion {
  const Emotion({required this.key, required this.opposite});

  /// Stable identifier persisted in the database. NEVER localized.
  final String key;

  /// [key] of the diametrically opposite emotion on the wheel.
  final String opposite;
}
