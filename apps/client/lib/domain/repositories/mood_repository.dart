import '../../data/local/database.dart';
import '../emotions/emotion_input.dart';

abstract interface class MoodRepository {
  /// Records an emotional check-in and returns its id.
  Future<String> add({
    required int mood,
    required DateTime occurredAt,
    String? note,
    List<EmotionInput> emotions,
    List<String> tagIds,
    List<String> tagNames,
    String? id,
  });

  Future<void> update({
    required String id,
    required int mood,
    String? note,
    List<EmotionInput> emotions,
    List<String> tagIds,
    List<String> tagNames,
  });

  Future<List<Tag>> tagsFor(String moodEntryId);
  Future<List<MoodEntry>> getAll();
  Future<MoodEntry?> getById(String id);
  Future<List<MoodEntryEmotion>> emotionsFor(String moodEntryId);
  Future<void> delete(String id);
}
