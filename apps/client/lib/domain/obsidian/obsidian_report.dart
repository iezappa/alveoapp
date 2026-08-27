/// Outcome of an Obsidian export or import.
class ObsidianReport {
  const ObsidianReport({
    this.exported = 0,
    this.created = 0,
    this.updated = 0,
    this.skipped = 0,
  });

  final int exported;
  final int created;
  final int updated;
  final int skipped;
}

class ObsidianException implements Exception {
  const ObsidianException(this.message);

  final String message;

  @override
  String toString() => 'ObsidianException: $message';
}
