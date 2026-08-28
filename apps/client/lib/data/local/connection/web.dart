import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// WASM SQLite persisted in the browser (IndexedDB / OPFS, chosen by drift).
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'alveo',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}

QueryExecutor openInMemory() =>
    throw UnsupportedError('In-memory database is only available natively.');
