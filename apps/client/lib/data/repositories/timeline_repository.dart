import '../../domain/timeline/timeline_item.dart';
import 'journal_repository.dart';
import 'mood_repository.dart';
import 'session_repository.dart';
import 'task_repository.dart';

class TimelineRepository {
  TimelineRepository(this._mood, this._journal, this._tasks, this._sessions);

  final MoodRepository _mood;
  final JournalRepository _journal;
  final TaskRepository _tasks;
  final SessionRepository _sessions;

  /// All activity merged into one list, newest first.
  ///
  /// Optionally bounded to the half-open range `[from, to)`.
  Future<List<TimelineItem>> getTimeline({DateTime? from, DateTime? to}) async {
    final moods = await _mood.getAll();
    final journals = await _journal.getAll();
    final tasks = await _tasks.getAll();
    final sessions = await _sessions.getAll();

    final items = <TimelineItem>[
      ...moods.map(MoodTimelineItem.new),
      ...journals.map(JournalTimelineItem.new),
      ...tasks.map(TaskTimelineItem.new),
      ...sessions.map(SessionTimelineItem.new),
    ];

    final filtered = items.where((i) {
      if (from != null && i.occurredAt.isBefore(from)) return false;
      if (to != null && !i.occurredAt.isBefore(to)) return false;
      return true;
    }).toList();

    filtered.sort((a, b) {
      final byTime = b.occurredAt.compareTo(a.occurredAt);
      // Deterministic tiebreak so equal timestamps keep a stable order.
      return byTime != 0 ? byTime : a.id.compareTo(b.id);
    });

    return filtered;
  }
}
