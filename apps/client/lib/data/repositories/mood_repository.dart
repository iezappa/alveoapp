import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/validation.dart';
import '../local/database.dart';

/// One emotion to attach to a mood entry.
class EmotionInput {
  const EmotionInput({required this.emotionKey, required this.intensity});

  final String emotionKey;
  final int intensity;
}

class MoodRepository {
  MoodRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Records an emotional check-in and returns its id.
  ///
  /// Domain rules (mood/intensity range, known emotion keys) are enforced
  /// here before anything is written.
  Future<String> add({
    required int mood,
    required DateTime occurredAt,
    String? note,
    List<EmotionInput> emotions = const [],
    List<String> tagIds = const [],
    String? id,
  }) async {
    validateMoodScale(mood);
    for (final e in emotions) {
      validateEmotionKey(e.emotionKey);
      validateIntensity(e.intensity);
    }

    final entryId = id ?? _uuid.v4();

    await _db.transaction(() async {
      await _db.into(_db.moodEntries).insert(
            MoodEntriesCompanion.insert(
              id: entryId,
              occurredAt: occurredAt,
              mood: mood,
              note: Value(note),
            ),
          );

      if (emotions.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.moodEntryEmotions, [
            for (final e in emotions)
              MoodEntryEmotionsCompanion.insert(
                moodEntryId: entryId,
                emotionKey: e.emotionKey,
                intensity: e.intensity,
              ),
          ]);
        });
      }

      if (tagIds.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.moodEntryTags, [
            for (final t in tagIds)
              MoodEntryTagsCompanion.insert(moodEntryId: entryId, tagId: t),
          ]);
        });
      }
    });

    return entryId;
  }

  /// All mood entries, newest first.
  Future<List<MoodEntry>> getAll() {
    return (_db.select(_db.moodEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .get();
  }

  Future<List<MoodEntryEmotion>> emotionsFor(String moodEntryId) {
    return (_db.select(_db.moodEntryEmotions)
          ..where((t) => t.moodEntryId.equals(moodEntryId)))
        .get();
  }

  /// Removes the entry and, by cascade, its emotions and tag links.
  Future<void> delete(String id) {
    return (_db.delete(_db.moodEntries)..where((t) => t.id.equals(id))).go();
  }
}
