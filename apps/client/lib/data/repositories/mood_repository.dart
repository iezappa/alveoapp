import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/emotions/emotion_input.dart';

import '../../domain/validation.dart';
import '../local/database.dart';
import 'tag_repository.dart';
import '../../domain/repositories/mood_repository.dart';

class DriftMoodRepository implements MoodRepository {
  DriftMoodRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Records an emotional check-in and returns its id.
  ///
  /// [tagNames] are found or created in the same transaction as the check-in,
  /// so a refused check-in leaves no new tags behind. Domain rules (mood/intensity range, known emotion keys) are enforced
  /// here before anything is written.
  @override
  Future<String> add({
    required int mood,
    required DateTime occurredAt,
    String? note,
    List<EmotionInput> emotions = const [],
    List<String> tagIds = const [],
    List<String> tagNames = const [],
    String? id,
  }) async {
    validateMoodScale(mood);
    for (final e in emotions) {
      validateEmotionKey(e.emotionKey);
      validateIntensity(e.intensity);
    }

    final entryId = id ?? _uuid.v4();

    await _db.transaction(() async {
      tagIds = [...tagIds, ...await _findOrCreateTags(tagNames)];
      await _db
          .into(_db.moodEntries)
          .insert(
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

  /// Rewrites the score, note, emotion set and tags of an existing check-in.
  @override
  Future<void> update({
    required String id,
    required int mood,
    String? note,
    List<EmotionInput> emotions = const [],
    List<String> tagIds = const [],
    List<String> tagNames = const [],
  }) async {
    validateMoodScale(mood);
    for (final e in emotions) {
      validateEmotionKey(e.emotionKey);
      validateIntensity(e.intensity);
    }

    await _db.transaction(() async {
      tagIds = [...tagIds, ...await _findOrCreateTags(tagNames)];
      await (_db.update(_db.moodEntries)..where((t) => t.id.equals(id))).write(
        MoodEntriesCompanion(
          mood: Value(mood),
          note: Value(note),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (_db.delete(
        _db.moodEntryEmotions,
      )..where((t) => t.moodEntryId.equals(id))).go();
      await (_db.delete(
        _db.moodEntryTags,
      )..where((t) => t.moodEntryId.equals(id))).go();
      if (emotions.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.moodEntryEmotions, [
            for (final e in emotions)
              MoodEntryEmotionsCompanion.insert(
                moodEntryId: id,
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
              MoodEntryTagsCompanion.insert(moodEntryId: id, tagId: t),
          ]);
        });
      }
    });
  }

  /// Must run inside the caller's transaction, so the tags share its fate.
  Future<List<String>> _findOrCreateTags(List<String> names) async {
    final tags = DriftTagRepository(_db, uuid: _uuid);
    return [for (final name in names) await tags.findOrCreate(name)];
  }

  /// Tags attached to [moodEntryId].
  @override
  Future<List<Tag>> tagsFor(String moodEntryId) {
    final query = _db.select(_db.tags).join([
      innerJoin(
        _db.moodEntryTags,
        _db.moodEntryTags.tagId.equalsExp(_db.tags.id),
      ),
    ])..where(_db.moodEntryTags.moodEntryId.equals(moodEntryId));
    return query.map((row) => row.readTable(_db.tags)).get();
  }

  /// All mood entries, newest first.
  @override
  Future<List<MoodEntry>> getAll() {
    return (_db.select(
      _db.moodEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])).get();
  }

  @override
  Future<MoodEntry?> getById(String id) {
    return (_db.select(
      _db.moodEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<List<MoodEntryEmotion>> emotionsFor(String moodEntryId) {
    return (_db.select(
      _db.moodEntryEmotions,
    )..where((t) => t.moodEntryId.equals(moodEntryId))).get();
  }

  /// Removes the entry and, by cascade, its emotions and tag links.
  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.moodEntries)..where((t) => t.id.equals(id))).go();
  }
}
