import '../../data/local/database.dart';

abstract interface class SessionRepository {
  Future<String> create({
    required DateTime scheduledFor,
    String? agendaMarkdown,
    String? notesMarkdown,
    String? takeawaysMarkdown,
    DateTime? createdAt,
    String? id,
  });

  Future<void> update({
    required String id,
    required DateTime scheduledFor,
    String? agendaMarkdown,
    String? notesMarkdown,
    String? takeawaysMarkdown,
  });

  Future<List<Session>> getAll();
  Future<Session?> getById(String id);
  Future<Session?> previousBefore(DateTime when);
  Future<Session?> nextFrom(DateTime when);
  Future<void> delete(String id);
}
