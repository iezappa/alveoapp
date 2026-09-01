import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/export/daily_markdown.dart';
import 'package:alveo/domain/session/pre_session_summary.dart';

void main() {
  test('an empty window renders a placeholder', () {
    final md = renderPreSessionSummary(
      PreSessionActivity(
        from: DateTime(2026, 8, 14),
        to: DateTime(2026, 8, 28),
      ),
    );
    expect(md, contains('Since the last session (2026-08-14 – 2026-08-28)'));
    expect(md, contains('Nothing was logged'));
  });

  test('rolls up mood, journal and tasks', () {
    final md = renderPreSessionSummary(
      PreSessionActivity(
        from: DateTime(2026, 8, 14),
        to: DateTime(2026, 8, 28),
        moods: [
          DayMoodEntry(
            occurredAt: DateTime(2026, 8, 20, 9),
            mood: 2,
            note: 'rough',
            emotions: [DayEmotion(key: 'fear', intensity: 3)],
          ),
          DayMoodEntry(occurredAt: DateTime(2026, 8, 24, 20), mood: 4),
        ],
        journals: [
          DayJournalEntry(
            createdAt: DateTime(2026, 8, 21),
            bodyMarkdown: 'Stood up for myself.',
            title: 'Win',
          ),
        ],
        tasks: [
          DayTask(title: 'Breathe daily', done: true, closingNote: 'helped'),
          DayTask(title: 'Call mum', done: false),
        ],
      ),
      emotionLabel: (k) => k == 'fear' ? 'Fear' : k,
    );

    expect(md, contains('**mood 3/5 across 2 · emotions: Fear · tasks 1/2**'));
    expect(md, contains('- 2026-08-20 09:00 — 2/5 — Fear (3) — "rough"'));
    expect(md, contains('- 2026-08-21 — Win — Stood up for myself.'));
    expect(md, contains('- [x] Breathe daily — helped'));
    expect(md, contains('- [ ] Call mum'));
  });
}
