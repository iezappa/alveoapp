import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../domain/insights/mood_trend.dart';
import '../../l10n/app_localizations.dart';
import 'mood_calendar.dart';

/// The mood-trend chart over a 30- or 90-day window.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  int _days = 30;
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shiftMonth(int by) => setState(
    () => _month = DateTime(_month.year, _month.month + by),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final entries = ref.watch(moodEntriesProvider).asData?.value ?? const [];
    final readings = entries.map(
      (e) => (occurredAt: e.occurredAt, mood: e.mood),
    );
    final points = dailyMoodAverages(
      readings,
      now: DateTime.now(),
      days: _days,
    );
    final monthly = monthlyMoodAverages(
      readings,
      _month.year,
      _month.month,
    );
    final present = points.whereType<double>().toList();
    final average = present.isEmpty
        ? null
        : present.reduce((a, b) => a + b) / present.length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.insightsTitle)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.all(kGutter),
            children: [
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 30, label: Text(l10n.insightsRange30)),
                  ButtonSegment(value: 90, label: Text(l10n.insightsRange90)),
                ],
                selected: {_days},
                onSelectionChanged: (s) => setState(() => _days = s.first),
              ),
              const SizedBox(height: 24),
              if (present.isEmpty)
                EmptyState(
                  icon: Icons.show_chart,
                  message: l10n.insightsEmpty,
                )
              else ...[
                Text(
                  l10n.insightsAverage(average!.toStringAsFixed(1)),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.insightsDaysLogged(present.length),
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 240,
                  child: LineChart(_chartData(points, scheme)),
                ),
              ],
              const SizedBox(height: 32),
              SectionLabel(l10n.insightsCalendar),
              const SizedBox(height: 8),
              MoodCalendar(
                month: _month,
                dailyAverages: monthly,
                onPrev: () => _shiftMonth(-1),
                onNext: () => _shiftMonth(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _chartData(List<double?> points, ColorScheme scheme) {
    final spots = [
      for (var i = 0; i < points.length; i++)
        if (points[i] != null) FlSpot(i.toDouble(), points[i]!),
    ];
    final lastIndex = (points.length - 1).toDouble();

    return LineChartData(
      minX: 0,
      maxX: lastIndex,
      minY: 1,
      maxY: 5,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 24,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (lastIndex / 3).clamp(1, lastIndex),
            reservedSize: 24,
            getTitlesWidget: (value, meta) {
              final daysAgo = points.length - value.round();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  daysAgo <= 1 ? '0' : '-$daysAgo',
                  style: TextStyle(
                    fontSize: 10,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineTouchData: const LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: scheme.primary,
          barWidth: 2,
          dotData: FlDotData(show: spots.length <= 45),
          belowBarData: BarAreaData(
            show: true,
            color: scheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}
