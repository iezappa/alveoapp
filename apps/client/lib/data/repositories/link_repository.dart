import 'package:drift/drift.dart';

import '../../domain/links/link_target_type.dart';
import '../../domain/links/linked_item.dart';
import '../local/database.dart';
import '../../domain/repositories/link_repository.dart';

/// Manages associations between a session and other records (tasks, journal
/// entries, mood entries).
class DriftLinkRepository implements LinkRepository {
  DriftLinkRepository(this._db);

  final AppDatabase _db;

  Future<void> link(String sessionId, LinkTargetType type, String targetId) {
    return _db
        .into(_db.sessionLinks)
        .insert(
          SessionLinksCompanion.insert(
            sessionId: sessionId,
            targetType: type,
            targetId: targetId,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> unlink(String sessionId, LinkTargetType type, String targetId) {
    return (_db.delete(_db.sessionLinks)..where(
          (t) =>
              t.sessionId.equals(sessionId) &
              t.targetType.equalsValue(type) &
              t.targetId.equals(targetId),
        ))
        .go();
  }

  /// Drops every link that points at [targetId] of [type]. Call this when the
  /// target record itself is deleted.
  Future<void> removeLinksTo(LinkTargetType type, String targetId) {
    return (_db.delete(_db.sessionLinks)..where(
          (t) => t.targetType.equalsValue(type) & t.targetId.equals(targetId),
        ))
        .go();
  }

  /// Items linked to [sessionId], resolved against live rows (dangling links
  /// skipped), newest first.
  Future<List<LinkedItem>> linkedItems(String sessionId) async {
    final links = await (_db.select(
      _db.sessionLinks,
    )..where((t) => t.sessionId.equals(sessionId))).get();

    final wanted = <LinkTargetType, Set<String>>{};
    for (final link in links) {
      wanted.putIfAbsent(link.targetType, () => {}).add(link.targetId);
    }

    final items = await _resolve(wanted);
    items.sort((a, b) => b.when.compareTo(a.when));
    return items;
  }

  /// Every task / journal / mood record not yet linked to [sessionId],
  /// newest first — the candidates for a new link.
  Future<List<LinkedItem>> linkableItems(String sessionId) async {
    final links = await (_db.select(
      _db.sessionLinks,
    )..where((t) => t.sessionId.equals(sessionId))).get();
    final taken = {
      for (final link in links) _key(link.targetType, link.targetId),
    };

    final all = await _resolveAll()
      ..removeWhere((i) => taken.contains(_key(i.type, i.id)));
    all.sort((a, b) => b.when.compareTo(a.when));
    return all;
  }

  String _key(LinkTargetType type, String id) => '${type.index}:$id';

  Future<List<LinkedItem>> _resolveAll() async {
    final tasks = await _db.select(_db.tasks).get();
    final journals = await _db.select(_db.journalEntries).get();
    final moods = await _db.select(_db.moodEntries).get();

    return [
      for (final t in tasks)
        LinkedItem(
          type: LinkTargetType.task,
          id: t.id,
          when: t.createdAt,
          title: t.title,
        ),
      for (final j in journals)
        LinkedItem(
          type: LinkTargetType.journal,
          id: j.id,
          when: j.createdAt,
          title: j.title,
        ),
      for (final m in moods)
        LinkedItem(type: LinkTargetType.mood, id: m.id, when: m.occurredAt),
    ];
  }

  Future<List<LinkedItem>> _resolve(
    Map<LinkTargetType, Set<String>> wanted,
  ) async {
    final result = <LinkedItem>[];

    final taskIds = wanted[LinkTargetType.task];
    if (taskIds != null && taskIds.isNotEmpty) {
      final rows = await (_db.select(
        _db.tasks,
      )..where((t) => t.id.isIn(taskIds.toList()))).get();
      result.addAll(
        rows.map(
          (t) => LinkedItem(
            type: LinkTargetType.task,
            id: t.id,
            when: t.createdAt,
            title: t.title,
          ),
        ),
      );
    }

    final journalIds = wanted[LinkTargetType.journal];
    if (journalIds != null && journalIds.isNotEmpty) {
      final rows = await (_db.select(
        _db.journalEntries,
      )..where((t) => t.id.isIn(journalIds.toList()))).get();
      result.addAll(
        rows.map(
          (j) => LinkedItem(
            type: LinkTargetType.journal,
            id: j.id,
            when: j.createdAt,
            title: j.title,
          ),
        ),
      );
    }

    final moodIds = wanted[LinkTargetType.mood];
    if (moodIds != null && moodIds.isNotEmpty) {
      final rows = await (_db.select(
        _db.moodEntries,
      )..where((t) => t.id.isIn(moodIds.toList()))).get();
      result.addAll(
        rows.map(
          (m) => LinkedItem(
            type: LinkTargetType.mood,
            id: m.id,
            when: m.occurredAt,
          ),
        ),
      );
    }

    return result;
  }
}
