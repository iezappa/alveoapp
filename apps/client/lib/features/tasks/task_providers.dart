import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/providers.dart';

/// Tasks ordered for display: open ones first, then by due date (soonest
/// first, undated last), then newest.
final taskListProvider = FutureProvider<List<Task>>((ref) async {
  final tasks = await ref.watch(taskRepositoryProvider).getAll();

  bool isOpen(Task t) =>
      t.status == TaskStatus.pending || t.status == TaskStatus.inProgress;

  final sorted = [...tasks]..sort((a, b) {
      if (isOpen(a) != isOpen(b)) return isOpen(a) ? -1 : 1;

      final aDue = a.dueDate;
      final bDue = b.dueDate;
      if (aDue != null && bDue != null && aDue != bDue) {
        return aDue.compareTo(bDue);
      }
      if (aDue == null && bDue != null) return 1;
      if (aDue != null && bDue == null) return -1;

      return b.createdAt.compareTo(a.createdAt);
    });

  return sorted;
});
