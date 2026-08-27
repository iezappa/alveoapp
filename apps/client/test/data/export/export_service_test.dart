import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/export/export_service.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/repositories/journal_repository.dart';
import 'package:terapia/data/repositories/mood_repository.dart';
import 'package:terapia/data/repositories/task_repository.dart';

void main() {
  late AppDatabase db;
  late ExportService service;

  setUp(() {
    db = AppDatabase.forTesting();
    service = ExportService(db);
  });
  tearDown(() => db.close());

  test('gathers only the requested day and renders it', () async {
    final mood = MoodRepository(db);
    final journal = JournalRepository(db);

    await mood.add(
      mood: 4,
      occurredAt: DateTime(2026, 8, 27, 9),
      note: 'ok',
      emotions: const [EmotionInput(emotionKey: 'joy', intensity: 3)],
    );
    await mood.add(mood: 1, occurredAt: DateTime(2026, 8, 28, 9)); // next day
    await journal.create(
      bodyMarkdown: '# hi',
      entryDate: DateTime(2026, 8, 27),
    );

    final data = await service.buildDailyExport(DateTime(2026, 8, 27));
    expect(data.moods, hasLength(1));
    expect(data.moods.single.mood, 4);
    expect(data.moods.single.emotions.single.key, 'joy');
    expect(data.journals, hasLength(1));

    final md = await service.buildDailyMarkdown(DateTime(2026, 8, 27));
    expect(md, contains('date: 2026-08-27'));
    expect(md, contains('### 09:00 — 4/5'));
    expect(md, contains('## Journal'));
  });

  test('includes tasks created or completed that day', () async {
    final tasks = TaskRepository(db);
    await tasks.create(title: 'made today', createdAt: DateTime(2026, 8, 27, 8));
    await tasks.create(title: 'made earlier', createdAt: DateTime(2026, 8, 1));
    final closedId =
        await tasks.create(title: 'closed today', createdAt: DateTime(2026, 8, 1));
    await tasks.close(
      closedId,
      closingNote: 'done',
      completedAt: DateTime(2026, 8, 27, 18),
    );

    final data = await service.buildDailyExport(DateTime(2026, 8, 27));

    expect(
      data.tasks.map((t) => t.title),
      containsAll(['made today', 'closed today']),
    );
    expect(data.tasks.map((t) => t.title), isNot(contains('made earlier')));
    expect(
      data.tasks.firstWhere((t) => t.title == 'closed today').done,
      isTrue,
    );
  });

  test('an empty day still renders a valid document', () async {
    final md = await service.buildDailyMarkdown(DateTime(2026, 8, 27));
    expect(md, contains('_No records for this day._'));
  });
}
