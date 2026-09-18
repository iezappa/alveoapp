import '../../data/local/database.dart';
import '../../data/local/tables.dart';

abstract interface class TaskRepository {
  /// Creates a task in one write, [status] and all, and returns its id.
  Future<String> create({
    required String title,
    String? descriptionMarkdown,
    DateTime? dueDate,
    TaskStatus status = TaskStatus.pending,
    String? closingNote,
    DateTime? createdAt,
    String? id,
  });

  Future<void> setStatus(String id, TaskStatus status);

  Future<void> update({
    required String id,
    required String title,
    String? descriptionMarkdown,
    DateTime? dueDate,
    required TaskStatus status,
    String? closingNote,
    DateTime? completedAt,
  });

  Future<Task?> getById(String id);

  /// Marks the task done and records how it went.
  Future<void> close(
    String id, {
    required String closingNote,
    DateTime? completedAt,
  });

  Future<List<Task>> getAll();
  Future<void> delete(String id);
}
