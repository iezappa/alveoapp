/// The record kinds that can be searched.
enum SearchType { mood, journal, task, session }

/// One match from a search, resolved enough to render and open.
class SearchHit {
  const SearchHit({
    required this.type,
    required this.id,
    required this.title,
    required this.snippet,
    required this.when,
    required this.route,
  });

  final SearchType type;
  final String id;
  final String title;

  /// A short excerpt around the match.
  final String snippet;

  final DateTime when;

  /// Where tapping the hit navigates.
  final String route;
}
