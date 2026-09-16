import 'dart:io';

import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/database_health.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('alveo_health_'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('reports a store that opens as healthy', () async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    expect(await probeDatabase(db), isA<DatabaseHealthy>());
  });

  test('reports a store that cannot be opened, rather than throwing', () async {
    final file = File('${dir.path}/alveo.sqlite')
      ..writeAsStringSync('this is not a sqlite database, not even close');
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    expect(await probeDatabase(db), isA<DatabaseUnopenable>());
  });
}
