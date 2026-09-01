import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/insights/mood_trend.dart';

void main() {
  final now = DateTime(2026, 8, 28, 15);

  test('averages readings per day, oldest first, over the window', () {
    final averages = dailyMoodAverages(
      [
        (occurredAt: DateTime(2026, 8, 28, 9), mood: 4),
        (occurredAt: DateTime(2026, 8, 28, 21), mood: 2), // same day -> avg 3
        (occurredAt: DateTime(2026, 8, 26, 12), mood: 5),
      ],
      now: now,
      days: 7,
    );

    expect(averages, hasLength(7));
    expect(averages.last, 3.0); // today
    expect(averages[4], 5.0); // two days ago
    expect(averages[5], isNull); // yesterday, no check-in
  });

  test('ignores readings outside the window', () {
    final averages = dailyMoodAverages(
      [
        (occurredAt: DateTime(2026, 8, 1), mood: 1),
        (occurredAt: DateTime(2026, 9, 5), mood: 5),
      ],
      now: now,
      days: 14,
    );

    expect(averages.every((a) => a == null), isTrue);
  });

  test('monthlyMoodAverages buckets by day of the given month', () {
    final month = monthlyMoodAverages(
      [
        (occurredAt: DateTime(2026, 8, 3, 9), mood: 4),
        (occurredAt: DateTime(2026, 8, 3, 22), mood: 2), // day 3 -> avg 3
        (occurredAt: DateTime(2026, 7, 3), mood: 1), // other month, ignored
      ],
      2026,
      8,
    );

    expect(month, hasLength(31));
    expect(month[2], 3.0); // day 3
    expect(month[0], isNull); // day 1
  });
}
