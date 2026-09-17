import '../../data/local/database.dart';
import '../cbt/cognitive_distortion.dart';

abstract interface class ThoughtRecordRepository {
  Future<String> create({
    required DateTime occurredAt,
    required String situation,
    required String automaticThought,
    int? beliefBefore,
    String? emotionLabel,
    int? emotionIntensityBefore,
    Set<CognitiveDistortion> distortions,
    String? alternativeThought,
    int? beliefAfter,
    int? emotionIntensityAfter,
    DateTime? createdAt,
    String? id,
  });

  Future<void> update({
    required String id,
    required DateTime occurredAt,
    required String situation,
    required String automaticThought,
    int? beliefBefore,
    String? emotionLabel,
    int? emotionIntensityBefore,
    Set<CognitiveDistortion> distortions,
    String? alternativeThought,
    int? beliefAfter,
    int? emotionIntensityAfter,
  });

  Future<List<ThoughtRecord>> getAll();
  Future<ThoughtRecord?> getById(String id);
  Future<Set<CognitiveDistortion>> distortionsFor(String recordId);
  Future<void> delete(String id);
}
