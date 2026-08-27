import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class SessionRepository {
  SessionRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  Future<String> create({
    required DateTime scheduledFor,
    String? agendaMarkdown,
    String? notesMarkdown,
    String? takeawaysMarkdown,
    DateTime? createdAt,
    String? id,
  }) async {
    final sessionId = id ?? _uuid.v4();
    await _db.into(_db.sessions).insert(
          SessionsCompanion.insert(
            id: sessionId,
            scheduledFor: scheduledFor,
            agendaMarkdown: Value(agendaMarkdown),
            notesMarkdown: Value(notesMarkdown),
            takeawaysMarkdown: Value(takeawaysMarkdown),
            createdAt: Value(createdAt ?? DateTime.now()),
          ),
        );
    return sessionId;
  }

  Future<void> update({
    required String id,
    required DateTime scheduledFor,
    String? agendaMarkdown,
    String? notesMarkdown,
    String? takeawaysMarkdown,
  }) {
    return (_db.update(_db.sessions)..where((t) => t.id.equals(id))).write(
      SessionsCompanion(
        scheduledFor: Value(scheduledFor),
        agendaMarkdown: Value(agendaMarkdown),
        notesMarkdown: Value(notesMarkdown),
        takeawaysMarkdown: Value(takeawaysMarkdown),
      ),
    );
  }

  /// All sessions, soonest-scheduled last (chronological).
  Future<List<Session>> getAll() {
    return (_db.select(_db.sessions)
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledFor)]))
        .get();
  }

  Future<Session?> getById(String id) {
    return (_db.select(_db.sessions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// The most recent session scheduled strictly before [when] — i.e. the one
  /// the next pre-session summary should cover activity since.
  Future<Session?> previousBefore(DateTime when) {
    return (_db.select(_db.sessions)
          ..where((t) => t.scheduledFor.isSmallerThanValue(when))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledFor)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// The next session scheduled at or after [when].
  Future<Session?> nextFrom(DateTime when) {
    return (_db.select(_db.sessions)
          ..where((t) => t.scheduledFor.isBiggerOrEqualValue(when))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledFor)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.sessions)..where((t) => t.id.equals(id))).go();
  }
}
