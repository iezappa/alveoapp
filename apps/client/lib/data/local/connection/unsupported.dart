import 'package:drift/drift.dart';

import '../storage_durability.dart';

QueryExecutor openConnection({
  required String name,
  required Uri sqlite3Uri,
  required Uri driftWorkerUri,
  void Function(StorageDurability)? onStorageChosen,
}) => throw UnsupportedError('No database backend for this platform.');

QueryExecutor openInMemory() =>
    throw UnsupportedError('In-memory database is only available natively.');
