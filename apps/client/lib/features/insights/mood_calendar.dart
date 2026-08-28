import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A month grid where each day is tinted by its average mood (1..5), grey when
/// there was no check-in.
class MoodCalendar extends StatelessWidget {
  const MoodCalendar({
    super.key,
    required this.month,
    required this.dailyAverages,
    required this.onPrev,
    required this.onNext,
  });

  /// Any day in the month to show (only year/month are used).
  final DateTime month;

  /// Average mood per day, indexed `day - 1`; `null` for days with no check-in.
  final List<double?> dailyAverages;

  final VoidCallback onPrev;
  final VoidCallback onNext;

  static const _low = Color(0xFFD9A08C);
  static const _high = Color(0xFF7FB0A1);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final firstOfMonth = DateTime(month.year, month.month);
    // Monday = 1 … Sunday = 7; grid starts on Monday.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final now = DateTime.now();
    final isCurrentMonth = now.year == month.year && now.month == month.month;

    Color cellColor(double? avg) => avg == null
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
        : Color.lerp(_low, _high, ((avg - 1) / 4).clamp(0.0, 1.0))!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              DateFormat.yMMMM(locale).format(firstOfMonth),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: isCurrentMonth ? null : onNext,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.E(
                      locale,
                    ).format(DateTime(2024, 1, 1 + i)), // 2024-01-01 is Monday
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            for (var i = 0; i < leadingBlanks; i++) const SizedBox(),
            for (var day = 1; day <= dailyAverages.length; day++)
              _DayCell(
                day: day,
                color: cellColor(dailyAverages[day - 1]),
                hasData: dailyAverages[day - 1] != null,
                isToday: isCurrentMonth && now.day == day,
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.color,
    required this.hasData,
    required this.isToday,
  });

  final int day;
  final Color color;
  final bool hasData;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: scheme.primary, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 11,
            color: hasData ? Colors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
