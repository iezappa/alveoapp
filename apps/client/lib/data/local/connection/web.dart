import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../storage_durability.dart';

/// WASM SQLite persisted in the browser (OPFS or IndexedDB, chosen by drift).
///
/// [onStorageChosen] hears which one drift settled on, once the first query
/// opens the connection, so the app can warn when it is not durable.
QueryExecutor openConnection({
  required String name,
  required Uri sqlite3Uri,
  required Uri driftWorkerUri,
  void Function(StorageDurability)? onStorageChosen,
}) {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: name,
      sqlite3Uri: sqlite3Uri,
      driftWorkerUri: driftWorkerUri,
    );
    onStorageChosen?.call(
      durabilityOfImplementation(result.chosenImplementation.name),
    );
    return result.resolvedExecutor;
  });
}

QueryExecutor openInMemory() =>
    throw UnsupportedError('In-memory database is only available natively.');
