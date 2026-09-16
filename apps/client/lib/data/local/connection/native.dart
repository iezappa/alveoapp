import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../storage_durability.dart';

/// File-backed database at `<app documents>/<name>.sqlite`.
///
/// A file on disk is always durable, so [onStorageChosen] is never called.
QueryExecutor openConnection({
  required String name,
  required Uri sqlite3Uri,
  required Uri driftWorkerUri,
  void Function(StorageDurability)? onStorageChosen,
}) {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, '$name.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

QueryExecutor openInMemory() => NativeDatabase.memory();
