import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'database.dart';

/// Removes the SQLite file and whatever journal sits next to it.
///
/// Must match where `connection/native.dart` opens the database.
Future<void> eraseLocalStore() async {
  final dir = await getApplicationDocumentsDirectory();
  final base = p.join(dir.path, '${AppDatabase.storeName}.sqlite');

  for (final suffix in const ['', '-wal', '-shm', '-journal']) {
    final file = File('$base$suffix');
    if (file.existsSync()) await file.delete();
  }
}
