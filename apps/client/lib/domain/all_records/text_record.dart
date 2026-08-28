/// Pure, framework-free model for the read-only "everything" view: one flat
/// list of every text the user has written, drawn from every source table.
library;

/// Where a [TextRecord] was distilled from.
enum TextRecordKind { journal, session, thoughtRecord, task, mood }

/// A single user-authored text, flattened from any source table.
class TextRecord {
  const TextRecord({
    required this.kind,
    required this.when,
    required this.body,
    this.title,
  });

  final TextRecordKind kind;

  /// The moment the record is filed under (entry date, session date, when a
  /// feeling occurred…). Used only for ordering and display.
  final DateTime when;

  /// Optional heading — a journal title, a task title, a thought-record
  /// situation. May be `null` or blank.
  final String? title;

  /// The full text. Multi-field records (a session's agenda + notes +
  /// takeaways) are already joined with blank lines by the caller.
  final String body;

  /// Whether this record carries anything worth showing.
  bool get hasText =>
      body.trim().isNotEmpty || (title?.trim().isNotEmpty ?? false);
}

/// Drops records with no text and returns the rest ordered newest-first.
List<TextRecord> sortedTextRecords(Iterable<TextRecord> records) {
  final kept = records.where((r) => r.hasText).toList();
  kept.sort((a, b) => b.when.compareTo(a.when));
  return kept;
}
