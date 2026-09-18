import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/journal/journal_section.dart';
import '../../domain/validation.dart';
import '../local/database.dart';
import '../../domain/emotions/emotion_input.dart';
import '../../domain/repositories/journal_repository.dart';

class DriftJournalRepository implements JournalRepository {
  DriftJournalRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Creates a journal entry and returns its id. [bodyMarkdown] is stored
  /// verbatim — it is the source of truth for the daily `.md` export.
  @override
  Future<String> create({
    required String bodyMarkdown,
    required DateTime entryDate,
    String? title,
    JournalSection section = JournalSection.oneLiner,
    bool isMonthlyReview = false,
    DateTime? createdAt,
    List<String> tagIds = const [],
    List<EmotionInput> emotions = const [],
    String? id,
  }) async {
    for (final e in emotions) {
      validateEmotionKey(e.emotionKey);
      validateIntensity(e.intensity);
    }

    final entryId = id ?? _uuid.v4();
    final now = createdAt ?? DateTime.now();

    await _db.transaction(() async {
      await _db
          .into(_db.journalEntries)
          .insert(
            JournalEntriesCompanion.insert(
              id: entryId,
              entryDate: entryDate,
              bodyMarkdown: bodyMarkdown,
              title: Value(title),
              section: Value(section),
              isMonthlyReview: Value(isMonthlyReview),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      if (emotions.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.journalEntryEmotions, [
            for (final e in emotions)
              JournalEntryEmotionsCompanion.insert(
                journalEntryId: entryId,
                emotionKey: e.emotionKey,
                intensity: e.intensity,
              ),
          ]);
        });
      }

      if (tagIds.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.journalEntryTags, [
            for (final t in tagIds)
              JournalEntryTagsCompanion.insert(
                journalEntryId: entryId,
                tagId: t,
              ),
          ]);
        });
      }
    });

    return entryId;
  }

  /// Rewrites the body and title and bumps `updatedAt`. A null [title]
  /// clears it. When [emotions] is given the emotion set is replaced in the
  /// same transaction, so a refused write leaves the entry as it was.
  @override
  Future<void> updateBody({
    required String id,
    required String bodyMarkdown,
    String? title,
    List<EmotionInput>? emotions,
    DateTime? updatedAt,
  }) async {
    for (final e in emotions ?? const <EmotionInput>[]) {
      validateEmotionKey(e.emotionKey);
      validateIntensity(e.intensity);
    }
    await _db.transaction(() async {
      await (_db.update(
        _db.journalEntries,
      )..where((t) => t.id.equals(id))).write(
        JournalEntriesCompanion(
          bodyMarkdown: Value(bodyMarkdown),
          title: Value(title),
          updatedAt: Value(updatedAt ?? DateTime.now()),
        ),
      );
      if (emotions != null) await _writeEmotions(id, emotions);
    });
  }

  /// All journal entries, newest first.
  @override
  Future<List<JournalEntry>> getAll() {
    return (_db.select(
      _db.journalEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  @override
  Future<JournalEntry?> getById(String id) {
    return (_db.select(
      _db.journalEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Entries in [section], newest first.
  @override
  Future<List<JournalEntry>> getBySection(JournalSection section) {
    return (_db.select(_db.journalEntries)
          ..where((t) => t.section.equalsValue(section))
          ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
        .get();
  }

  /// The monthly-review entry filed under the month containing [month], if one
  /// exists. Only meaningful for [JournalSection.oneLiner].
  @override
  Future<JournalEntry?> getMonthlyReview(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    return (_db.select(_db.journalEntries)
          ..where(
            (t) =>
                t.isMonthlyReview.equals(true) &
                t.entryDate.isBiggerOrEqualValue(start) &
                t.entryDate.isSmallerThanValue(end),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  /// Entries filed under [day] (compared on the date part only).
  @override
  Future<List<JournalEntry>> getForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.journalEntries)
          ..where(
            (t) =>
                t.entryDate.isBiggerOrEqualValue(start) &
                t.entryDate.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Emotions attached to [journalEntryId].
  @override
  Future<List<JournalEntryEmotion>> emotionsFor(String journalEntryId) {
    return (_db.select(
      _db.journalEntryEmotions,
    )..where((t) => t.journalEntryId.equals(journalEntryId))).get();
  }

  /// Replaces the whole emotion set of [id] with [emotions].
  @override
  Future<void> replaceEmotions(String id, List<EmotionInput> emotions) async {
    for (final e in emotions) {
      validateEmotionKey(e.emotionKey);
      validateIntensity(e.intensity);
    }
    await _db.transaction(() async {
      // The removed rows leave nothing behind, so the entry carries the change.
      await (_db.update(_db.journalEntries)..where((t) => t.id.equals(id)))
          .write(JournalEntriesCompanion(updatedAt: Value(DateTime.now())));
      await _writeEmotions(id, emotions);
    });
  }

  Future<void> _writeEmotions(String id, List<EmotionInput> emotions) async {
    await (_db.delete(
      _db.journalEntryEmotions,
    )..where((t) => t.journalEntryId.equals(id))).go();
    if (emotions.isNotEmpty) {
      await _db.batch((b) {
        b.insertAll(_db.journalEntryEmotions, [
          for (final e in emotions)
            JournalEntryEmotionsCompanion.insert(
              journalEntryId: id,
              emotionKey: e.emotionKey,
              intensity: e.intensity,
            ),
        ]);
      });
    }
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
  }
}
