import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../../domain/repositories/tag_repository.dart';

/// Shared context labels (people, places, situations).
class DriftTagRepository implements TagRepository {
  DriftTagRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Future<List<Tag>> all() {
    return (_db.select(
      _db.tags,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  /// The id of the tag named [name] (trimmed, case-insensitive match),
  /// creating it if it does not exist yet.
  @override
  Future<String> findOrCreate(String name) async {
    final trimmed = name.trim();
    final existing =
        await (_db.select(_db.tags)
              ..where((t) => t.name.lower().equals(trimmed.toLowerCase())))
            .getSingleOrNull();
    if (existing != null) return existing.id;

    final id = _uuid.v4();
    await _db
        .into(_db.tags)
        .insert(TagsCompanion.insert(id: id, name: trimmed));
    return id;
  }

  /// All mood-entry ↔ tag links, for filtering by tag.
  @override
  Future<List<MoodEntryTag>> moodTagLinks() =>
      _db.select(_db.moodEntryTags).get();
}
