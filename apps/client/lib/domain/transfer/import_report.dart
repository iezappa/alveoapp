/// Outcome of importing a backup: how many rows were added versus skipped
/// (already present) per table.
class ImportReport {
  ImportReport(this.tables);

  final Map<String, TableImport> tables;

  int get totalInserted => tables.values.fold(0, (sum, t) => sum + t.inserted);

  int get totalSkipped => tables.values.fold(0, (sum, t) => sum + t.skipped);
}

class TableImport {
  const TableImport({required this.inserted, required this.skipped});

  final int inserted;
  final int skipped;
}

/// Thrown when a backup file can't be imported (bad format, or produced by a
/// newer app version).
class ImportException implements Exception {
  const ImportException(this.message);

  final String message;

  @override
  String toString() => 'ImportException: $message';
}
