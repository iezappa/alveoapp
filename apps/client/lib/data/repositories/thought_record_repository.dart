import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/cbt/cognitive_distortion.dart';
import '../local/database.dart';

class ThoughtRecordRepository {
  ThoughtRecordRepository(this._db, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  int? _clampPercent(int? v) => v?.clamp(0, 100);
  int? _clampIntensity(int? v) => v?.clamp(0, 10);

  Future<String> create({
    required DateTime occurredAt,
    required String situation,
    required String automaticThought,
    int? beliefBefore,
    String? emotionLabel,
    int? emotionIntensityBefore,
    Set<CognitiveDistortion> distortions = const {},
    String? alternativeThought,
    int? beliefAfter,
    int? emotionIntensityAfter,
    DateTime? createdAt,
    String? id,
  }) async {
    final recordId = id ?? _uuid.v4();

    await _db.transaction(() async {
      await _db
          .into(_db.thoughtRecords)
          .insert(
            ThoughtRecordsCompanion.insert(
              id: recordId,
              occurredAt: occurredAt,
              situation: situation,
              automaticThought: automaticThought,
              beliefBefore: Value(_clampPercent(beliefBefore)),
              emotionLabel: Value(emotionLabel),
              emotionIntensityBefore: Value(
                _clampIntensity(emotionIntensityBefore),
              ),
              alternativeThought: Value(alternativeThought),
              beliefAfter: Value(_clampPercent(beliefAfter)),
              emotionIntensityAfter: Value(
                _clampIntensity(emotionIntensityAfter),
              ),
              createdAt: Value(createdAt ?? DateTime.now()),
            ),
          );
      await _writeDistortions(recordId, distortions);
    });

    return recordId;
  }

  Future<void> update({
    required String id,
    required DateTime occurredAt,
    required String situation,
    required String automaticThought,
    int? beliefBefore,
    String? emotionLabel,
    int? emotionIntensityBefore,
    Set<CognitiveDistortion> distortions = const {},
    String? alternativeThought,
    int? beliefAfter,
    int? emotionIntensityAfter,
  }) async {
    await _db.transaction(() async {
      await (_db.update(
        _db.thoughtRecords,
      )..where((t) => t.id.equals(id))).write(
        ThoughtRecordsCompanion(
          occurredAt: Value(occurredAt),
          situation: Value(situation),
          automaticThought: Value(automaticThought),
          beliefBefore: Value(_clampPercent(beliefBefore)),
          emotionLabel: Value(emotionLabel),
          emotionIntensityBefore: Value(
            _clampIntensity(emotionIntensityBefore),
          ),
          alternativeThought: Value(alternativeThought),
          beliefAfter: Value(_clampPercent(beliefAfter)),
          emotionIntensityAfter: Value(_clampIntensity(emotionIntensityAfter)),
        ),
      );
      await (_db.delete(
        _db.thoughtRecordDistortions,
      )..where((t) => t.recordId.equals(id))).go();
      await _writeDistortions(id, distortions);
    });
  }

  Future<void> _writeDistortions(
    String recordId,
    Set<CognitiveDistortion> distortions,
  ) async {
    if (distortions.isEmpty) return;
    await _db.batch((b) {
      b.insertAll(_db.thoughtRecordDistortions, [
        for (final d in distortions)
          ThoughtRecordDistortionsCompanion.insert(
            recordId: recordId,
            distortion: d,
          ),
      ]);
    });
  }

  /// All records, most recent situation first.
  Future<List<ThoughtRecord>> getAll() {
    return (_db.select(
      _db.thoughtRecords,
    )..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])).get();
  }

  Future<ThoughtRecord?> getById(String id) {
    return (_db.select(
      _db.thoughtRecords,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<Set<CognitiveDistortion>> distortionsFor(String recordId) async {
    final rows = await (_db.select(
      _db.thoughtRecordDistortions,
    )..where((t) => t.recordId.equals(recordId))).get();
    return rows.map((r) => r.distortion).toSet();
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.thoughtRecords)..where((t) => t.id.equals(id))).go();
  }
}
