/// A single motivational quote, stored bilingually so it can be shown in the
/// reader's chosen language with no network call.
///
/// Sources are deliberately limited to well-documented or public-domain
/// authors (Stoics, Tao Te Ching, Dhammapada, Rumi, Gibran, Thoreau,
/// Montaigne, Machado, proverbs) so every attribution here can be trusted.
class DailyQuote {
  const DailyQuote({
    required this.textEs,
    required this.textEn,
    required this.author,
    this.source,
  });

  final String textEs;
  final String textEn;
  final String author;

  /// The work the line is drawn from, when it has a stable one.
  final String? source;

  /// The quote text for [languageCode] ('en' → English, anything else → Spanish).
  String text(String languageCode) => languageCode == 'en' ? textEn : textEs;

  /// "Author" or "Author · Source" for display under the quote.
  String get attribution => source == null ? author : '$author · $source';
}
