/// The notebooks a journal entry can belong to.
///
/// Stored by index via Drift's `intEnum`. APPEND-ONLY: never reorder or remove
/// values, or existing rows decode to the wrong section.
enum JournalSection {
  /// "Diario" — short one-line-a-day entries, with optional monthly reviews.
  oneLiner,
  student,
  creative,
  freedom,
  therapy,

  /// Wins and things to be grateful for.
  winLog,
}
