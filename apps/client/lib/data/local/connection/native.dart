import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// File-backed database at `<app documents>/alveo.sqlite`.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'alveo.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

QueryExecutor openInMemory() => NativeDatabase.memory();
