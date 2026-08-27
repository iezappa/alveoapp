import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../local/tables.dart';

class TaskRepository {
  TaskRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Creates a task in [TaskStatus.pending] and returns its id.
  Future<String> create({
    required String title,
    String? descriptionMarkdown,
    DateTime? dueDate,
    DateTime? createdAt,
    String? id,
  }) async {
    final taskId = id ?? _uuid.v4();

    await _db.into(_db.tasks).insert(
          TasksCompanion.insert(
            id: taskId,
            title: title,
            status: TaskStatus.pending,
            descriptionMarkdown: Value(descriptionMarkdown),
            dueDate: Value(dueDate),
            createdAt: Value(createdAt ?? DateTime.now()),
          ),
        );

    return taskId;
  }

  Future<void> setStatus(String id, TaskStatus status) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(status: Value(status)));
  }

  /// Marks the task done and records how it went.
  Future<void> close(
    String id, {
    required String closingNote,
    DateTime? completedAt,
  }) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        status: const Value(TaskStatus.done),
        completedAt: Value(completedAt ?? DateTime.now()),
        closingNote: Value(closingNote),
      ),
    );
  }

  /// All tasks, newest first.
  Future<List<Task>> getAll() {
    return (_db.select(_db.tasks)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }
}
