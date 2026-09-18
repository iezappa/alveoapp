import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../local/tables.dart';
import '../../domain/repositories/task_repository.dart';

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Creates a task in [status] (pending unless told otherwise) and returns
  /// its id. It is a single insert, so a task is never left half-saved.
  @override
  Future<String> create({
    required String title,
    String? descriptionMarkdown,
    DateTime? dueDate,
    TaskStatus status = TaskStatus.pending,
    String? closingNote,
    DateTime? createdAt,
    String? id,
  }) async {
    final taskId = id ?? _uuid.v4();
    final now = DateTime.now();

    await _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            id: taskId,
            title: title,
            status: status,
            descriptionMarkdown: Value(descriptionMarkdown),
            dueDate: Value(dueDate),
            closingNote: Value(closingNote),
            completedAt: Value(status == TaskStatus.done ? now : null),
            createdAt: Value(createdAt ?? now),
          ),
        );

    return taskId;
  }

  /// Changes only the status, keeping `completedAt` consistent (set when the
  /// task becomes done, cleared otherwise).
  @override
  Future<void> setStatus(String id, TaskStatus status) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        updatedAt: Value(DateTime.now()),
        status: Value(status),
        completedAt: Value(status == TaskStatus.done ? DateTime.now() : null),
      ),
    );
  }

  /// Overwrites the editable fields of an existing task.
  @override
  Future<void> update({
    required String id,
    required String title,
    String? descriptionMarkdown,
    DateTime? dueDate,
    required TaskStatus status,
    String? closingNote,
    DateTime? completedAt,
  }) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        updatedAt: Value(DateTime.now()),
        title: Value(title),
        descriptionMarkdown: Value(descriptionMarkdown),
        dueDate: Value(dueDate),
        status: Value(status),
        closingNote: Value(closingNote),
        completedAt: Value(
          status == TaskStatus.done ? (completedAt ?? DateTime.now()) : null,
        ),
      ),
    );
  }

  @override
  Future<Task?> getById(String id) {
    return (_db.select(
      _db.tasks,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Marks the task done and records how it went.
  @override
  Future<void> close(
    String id, {
    required String closingNote,
    DateTime? completedAt,
  }) {
    return (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        updatedAt: Value(DateTime.now()),
        status: const Value(TaskStatus.done),
        completedAt: Value(completedAt ?? DateTime.now()),
        closingNote: Value(closingNote),
      ),
    );
  }

  /// All tasks, newest first.
  @override
  Future<List<Task>> getAll() {
    return (_db.select(
      _db.tasks,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }
}
