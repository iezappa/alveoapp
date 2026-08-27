import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class JournalRepository {
  JournalRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Creates a journal entry and returns its id. [bodyMarkdown] is stored
  /// verbatim — it is the source of truth for the daily `.md` export.
  Future<String> create({
    required String bodyMarkdown,
    required DateTime entryDate,
    String? title,
    DateTime? createdAt,
    List<String> tagIds = const [],
    String? id,
  }) async {
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
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

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
  /// clears it.
  Future<void> updateBody({
    required String id,
    required String bodyMarkdown,
    String? title,
    DateTime? updatedAt,
  }) {
    return (_db.update(
      _db.journalEntries,
    )..where((t) => t.id.equals(id))).write(
      JournalEntriesCompanion(
        bodyMarkdown: Value(bodyMarkdown),
        title: Value(title),
        updatedAt: Value(updatedAt ?? DateTime.now()),
      ),
    );
  }

  /// All journal entries, newest first.
  Future<List<JournalEntry>> getAll() {
    return (_db.select(
      _db.journalEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<JournalEntry?> getById(String id) {
    return (_db.select(
      _db.journalEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Entries filed under [day] (compared on the date part only).
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

  Future<void> delete(String id) {
    return (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
  }
}
