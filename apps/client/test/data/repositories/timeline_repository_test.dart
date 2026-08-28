import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/local/tables.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/repositories/timeline_repository.dart';
import 'package:alveo/domain/timeline/timeline_item.dart';
import 'package:alveo/domain/validation.dart';

void main() {
  late AppDatabase db;
  late MoodRepository mood;
  late JournalRepository journal;
  late TaskRepository tasks;
  late SessionRepository sessions;
  late TimelineRepository timeline;

  setUp(() {
    db = AppDatabase.forTesting();
    mood = MoodRepository(db);
    journal = JournalRepository(db);
    tasks = TaskRepository(db);
    sessions = SessionRepository(db);
    timeline = TimelineRepository(mood, journal, tasks, sessions);
  });
  tearDown(() => db.close());

  test('merges the three sources, newest first', () async {
    await mood.add(mood: 3, occurredAt: DateTime(2026, 8, 20, 8), id: 'm');
    await journal.create(
      bodyMarkdown: '# hi',
      entryDate: DateTime(2026, 8, 21),
      createdAt: DateTime(2026, 8, 21, 9),
      id: 'j',
    );
    await tasks.create(
      title: 'breathe',
      createdAt: DateTime(2026, 8, 19, 7),
      id: 't',
    );

    final items = await timeline.getTimeline();

    expect(items.map((i) => i.id).toList(), ['j', 'm', 't']);
    expect(items[0], isA<JournalTimelineItem>());
    expect(items[1], isA<MoodTimelineItem>());
    expect(items[2], isA<TaskTimelineItem>());
  });

  test('sessions appear on the timeline at their scheduled time', () async {
    await mood.add(mood: 3, occurredAt: DateTime(2026, 8, 20, 8), id: 'm');
    await sessions.create(scheduledFor: DateTime(2026, 8, 22, 10), id: 's');

    final items = await timeline.getTimeline();

    expect(items.first, isA<SessionTimelineItem>());
    expect(items.first.id, 's');
  });

  test('bounds results to the half-open [from, to) range', () async {
    await mood.add(mood: 3, occurredAt: DateTime(2026, 8, 1), id: 'a');
    await mood.add(mood: 3, occurredAt: DateTime(2026, 8, 10), id: 'b');
    await mood.add(mood: 3, occurredAt: DateTime(2026, 8, 20), id: 'c');

    final items = await timeline.getTimeline(
      from: DateTime(2026, 8, 10),
      to: DateTime(2026, 8, 20),
    );

    // 'a' is before `from`; 'c' sits exactly on `to`, which is excluded.
    expect(items.map((i) => i.id), ['b']);
  });

  test(
    'mood.add rejects an out-of-range score before writing anything',
    () async {
      await expectLater(
        mood.add(mood: 9, occurredAt: DateTime(2026, 8, 20)),
        throwsA(isA<DomainValidationException>()),
      );
      expect(await mood.getAll(), isEmpty);
    },
  );

  test('mood.add persists emotions and cascades on delete', () async {
    await mood.add(
      mood: 4,
      occurredAt: DateTime(2026, 8, 20),
      emotions: const [
        EmotionInput(emotionKey: 'joy', intensity: 3),
        EmotionInput(emotionKey: 'trust', intensity: 2),
      ],
      id: 'm1',
    );
    expect(await mood.emotionsFor('m1'), hasLength(2));

    await mood.delete('m1');
    expect(await mood.emotionsFor('m1'), isEmpty);
  });

  test('task.close records the note and completion time', () async {
    await tasks.create(title: 'journal daily', id: 'k1');
    await tasks.close(
      'k1',
      closingNote: 'did it 5/7 days',
      completedAt: DateTime(2026, 8, 26),
    );

    final task = (await tasks.getAll()).single;
    expect(task.status, TaskStatus.done);
    expect(task.closingNote, 'did it 5/7 days');
    expect(task.completedAt, DateTime(2026, 8, 26));
  });

  test('journal.getForDay filters by the entry date', () async {
    await journal.create(
      bodyMarkdown: 'a',
      entryDate: DateTime(2026, 8, 20),
      id: 'j1',
    );
    await journal.create(
      bodyMarkdown: 'b',
      entryDate: DateTime(2026, 8, 21),
      id: 'j2',
    );

    final day = await journal.getForDay(DateTime(2026, 8, 20, 15));
    expect(day.map((e) => e.id), ['j1']);
  });
}
