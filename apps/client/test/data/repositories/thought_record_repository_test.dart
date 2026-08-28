import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/thought_record_repository.dart';
import 'package:alveo/domain/cbt/cognitive_distortion.dart';

void main() {
  late AppDatabase db;
  late ThoughtRecordRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = ThoughtRecordRepository(db);
  });
  tearDown(() => db.close());

  test('create round-trips the chain and distortions', () async {
    final id = await repo.create(
      occurredAt: DateTime(2026, 8, 20, 9),
      situation: 'Meeting ran long',
      automaticThought: 'I always mess up',
      beliefBefore: 80,
      emotionLabel: 'anxious',
      emotionIntensityBefore: 8,
      distortions: {
        CognitiveDistortion.allOrNothing,
        CognitiveDistortion.overgeneralization,
      },
      alternativeThought: 'It ran long for everyone',
      beliefAfter: 30,
      emotionIntensityAfter: 4,
    );

    final r = await repo.getById(id);
    expect(r!.situation, 'Meeting ran long');
    expect(r.beliefBefore, 80);
    expect(r.emotionLabel, 'anxious');
    expect(r.emotionIntensityAfter, 4);
    expect(await repo.distortionsFor(id), {
      CognitiveDistortion.allOrNothing,
      CognitiveDistortion.overgeneralization,
    });
  });

  test('update replaces distortions and clamps out-of-range ratings', () async {
    final id = await repo.create(
      occurredAt: DateTime(2026, 8, 20),
      situation: 's',
      automaticThought: 't',
      distortions: {CognitiveDistortion.labeling},
    );

    await repo.update(
      id: id,
      occurredAt: DateTime(2026, 8, 21),
      situation: 's2',
      automaticThought: 't2',
      beliefBefore: 150,
      emotionIntensityBefore: 42,
      distortions: {CognitiveDistortion.catastrophizing},
    );

    final r = await repo.getById(id);
    expect(r!.situation, 's2');
    expect(r.beliefBefore, 100);
    expect(r.emotionIntensityBefore, 10);
    expect(await repo.distortionsFor(id), {
      CognitiveDistortion.catastrophizing,
    });
  });

  test('delete cascades the distortions', () async {
    final id = await repo.create(
      occurredAt: DateTime(2026, 8, 20),
      situation: 's',
      automaticThought: 't',
      distortions: {CognitiveDistortion.personalization},
    );

    await repo.delete(id);
    expect(await repo.distortionsFor(id), isEmpty);
    expect(await repo.getAll(), isEmpty);
  });
}
