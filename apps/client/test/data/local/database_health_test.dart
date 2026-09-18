import 'dart:io';

import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/database_health.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../generated_migrations/schema.dart';

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

  group('a store an older version of the app already holds open', () {
    // On the web every tab shares one drift worker, and the first tab to
    // connect opens the store. A tab still running the previous release keeps
    // it open at the old schema; a tab with this release then connects to
    // that same open store and drift, seeing it already open, never runs the
    // upgrade. Every write then fails on a column the old schema lacks.
    Future<AppDatabase> joinStoreOpenedAtV8() async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final schema = await SchemaVerifier(GeneratedHelper()).schemaAt(8);
      final connection = schema.newConnection();
      await _OlderRelease(connection).customSelect('SELECT 1').get();

      final db = AppDatabase(connection.executor);
      addTearDown(db.close);
      return db;
    }

    test('reads fail and edits are refused, the bug being guarded', () async {
      final db = await joinStoreOpenedAtV8();
      final moods = DriftMoodRepository(db);
      final id = await moods.add(mood: 3, occurredAt: DateTime(2026, 9));

      await expectLater(moods.getAll(), throwsA(anything));
      await expectLater(moods.update(id: id, mood: 4), throwsA(anything));
    });

    test('is reported as held by an older version, not healthy', () async {
      final db = await joinStoreOpenedAtV8();

      final health = await probeDatabase(db);

      expect(health, isA<DatabaseHeldByOlderVersion>());
      expect((health as DatabaseHeldByOlderVersion).foundVersion, 8);
    });
  });
}

class _OlderRelease extends GeneratedDatabase {
  _OlderRelease(super.executor);

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  int get schemaVersion => 8;
}
