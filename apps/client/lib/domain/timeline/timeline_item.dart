import '../../data/local/database.dart';

/// One entry in the unified chronological timeline.
///
/// The three Fase 1 record types are merged and sorted in Dart rather than
/// through a SQL `UNION` view: at personal-scale data volumes the cost is
/// nil, and the result stays fully typed and testable.
sealed class TimelineItem {
  const TimelineItem();

  /// Identifier of the underlying record.
  String get id;

  /// The moment this item is placed at on the timeline.
  DateTime get occurredAt;
}

final class MoodTimelineItem extends TimelineItem {
  const MoodTimelineItem(this.entry);

  final MoodEntry entry;

  @override
  String get id => entry.id;

  @override
  DateTime get occurredAt => entry.occurredAt;
}

final class JournalTimelineItem extends TimelineItem {
  const JournalTimelineItem(this.entry);

  final JournalEntry entry;

  @override
  String get id => entry.id;

  @override
  DateTime get occurredAt => entry.createdAt;
}

final class TaskTimelineItem extends TimelineItem {
  const TaskTimelineItem(this.task);

  final Task task;

  @override
  String get id => task.id;

  @override
  DateTime get occurredAt => task.createdAt;
}

final class SessionTimelineItem extends TimelineItem {
  const SessionTimelineItem(this.session);

  final Session session;

  @override
  String get id => session.id;

  @override
  DateTime get occurredAt => session.scheduledFor;
}
