/// A mood reading reduced to the two fields the trend needs.
typedef MoodReading = ({DateTime occurredAt, int mood});

/// Average mood (1..5) for each of the [days] calendar days ending on [now]'s
/// day, oldest first. A day with no check-in is `null`.
List<double?> dailyMoodAverages(
  Iterable<MoodReading> readings, {
  required DateTime now,
  int days = 14,
}) {
  final start = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: days - 1));
  final buckets = List.generate(days, (_) => <int>[]);

  for (final r in readings) {
    final day = DateTime(
      r.occurredAt.year,
      r.occurredAt.month,
      r.occurredAt.day,
    );
    final index = day.difference(start).inDays;
    if (index >= 0 && index < days) buckets[index].add(r.mood);
  }

  return [
    for (final bucket in buckets)
      bucket.isEmpty
          ? null
          : bucket.reduce((a, b) => a + b) / bucket.length,
  ];
}

/// Average mood for each day of [month] in [year], indexed `day - 1`. A day
/// with no check-in is `null`.
List<double?> monthlyMoodAverages(
  Iterable<MoodReading> readings,
  int year,
  int month,
) {
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final buckets = List.generate(daysInMonth, (_) => <int>[]);

  for (final r in readings) {
    if (r.occurredAt.year == year && r.occurredAt.month == month) {
      buckets[r.occurredAt.day - 1].add(r.mood);
    }
  }

  return [
    for (final bucket in buckets)
      bucket.isEmpty
          ? null
          : bucket.reduce((a, b) => a + b) / bucket.length,
  ];
}
