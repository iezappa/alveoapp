import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/domain/export/daily_markdown.dart';

void main() {
  final day = DateTime(2026, 8, 27);

  test('an empty day renders frontmatter and a placeholder body', () {
    final md = renderDailyMarkdown(DailyExport(day: day));

    expect(md, contains('date: 2026-08-27'));
    expect(md, contains('# 2026-08-27'));
    expect(md, contains('_No records for this day._'));
    expect(md, isNot(contains('mood_avg')));
  });

  test('frontmatter summarises mood, emotions and tasks', () {
    final md = renderDailyMarkdown(
      DailyExport(
        day: day,
        moods: [
          DayMoodEntry(
            occurredAt: DateTime(2026, 8, 27, 9, 5),
            mood: 4,
            emotions: const [DayEmotion(key: 'joy', intensity: 3)],
          ),
          DayMoodEntry(occurredAt: DateTime(2026, 8, 27, 20), mood: 2),
        ],
        tasks: const [
          DayTask(title: 'Breathe', done: true, closingNote: 'ok'),
          DayTask(title: 'Journal', done: false),
        ],
      ),
    );

    expect(md, contains('mood_avg: 3')); // (4 + 2) / 2
    expect(md, contains('emotions: [joy]'));
    expect(md, contains('tasks_completed: 1/2'));
    expect(md, contains('### 09:05 — 4/5'));
    expect(md, contains('Emotions: joy (3)'));
    expect(md, contains('- [x] Breathe — ok'));
    expect(md, contains('- [ ] Journal'));
  });

  test('mood_avg keeps one decimal when it is not whole', () {
    final md = renderDailyMarkdown(
      DailyExport(
        day: day,
        moods: [
          DayMoodEntry(occurredAt: DateTime(2026, 8, 27, 9), mood: 4),
          DayMoodEntry(occurredAt: DateTime(2026, 8, 27, 10), mood: 3),
        ],
      ),
    );
    expect(md, contains('mood_avg: 3.5'));
  });

  test('journal body is copied verbatim', () {
    const body = '# Notes\n\n- talked about **boundaries**\n\n> a quote\n';
    final md = renderDailyMarkdown(
      DailyExport(
        day: day,
        journals: [
          DayJournalEntry(
            createdAt: DateTime(2026, 8, 27, 22, 30),
            title: 'Session 3',
            bodyMarkdown: body,
          ),
        ],
      ),
    );

    expect(md, contains('### 22:30 — Session 3'));
    expect(md, contains('- talked about **boundaries**'));
    expect(md, contains('> a quote'));
  });

  test('emotionLabel maps keys in the body but not the frontmatter', () {
    final md = renderDailyMarkdown(
      DailyExport(
        day: day,
        moods: [
          DayMoodEntry(
            occurredAt: DateTime(2026, 8, 27, 9),
            mood: 3,
            emotions: const [DayEmotion(key: 'joy', intensity: 2)],
          ),
        ],
      ),
      emotionLabel: (k) => k == 'joy' ? 'Alegría' : k,
    );

    expect(md, contains('Emotions: Alegría (2)'));
    expect(md, contains('emotions: [joy]'));
  });
}
