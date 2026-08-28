/// Pure, framework-free rendering of the activity between two therapy sessions
/// into a Markdown block, meant to be dropped into a session's agenda as
/// preparation. NO AI — it is a plain roll-up of what was logged.
library;

import '../export/daily_markdown.dart';

class PreSessionActivity {
  const PreSessionActivity({
    required this.from,
    required this.to,
    this.moods = const [],
    this.journals = const [],
    this.tasks = const [],
  });

  /// Start of the window (the previous session, or a fallback lookback).
  final DateTime from;

  /// End of the window (this session).
  final DateTime to;

  final List<DayMoodEntry> moods;
  final List<DayJournalEntry> journals;
  final List<DayTask> tasks;

  bool get isEmpty => moods.isEmpty && journals.isEmpty && tasks.isEmpty;
}

String _date(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String _dateTime(DateTime d) =>
    '${_date(d)} '
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String _trimNumber(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

/// Renders [a] to a Markdown block. [emotionLabel] maps an emotion key to a
/// display name; when omitted the raw key is used.
String renderPreSessionSummary(
  PreSessionActivity a, {
  String Function(String emotionKey)? emotionLabel,
}) {
  String label(String key) => emotionLabel?.call(key) ?? key;

  final buffer = StringBuffer()
    ..writeln('## Since the last session (${_date(a.from)} – ${_date(a.to)})');

  if (a.isEmpty) {
    buffer.writeln();
    buffer.writeln('_Nothing was logged in this window._');
    return buffer.toString();
  }

  // --- One-line roll-up ---------------------------------------------------
  final summary = <String>[];
  if (a.moods.isNotEmpty) {
    final avg = a.moods.map((m) => m.mood).reduce((x, y) => x + y) /
        a.moods.length;
    summary.add('mood ${_trimNumber(avg)}/5 across ${a.moods.length}');
  }
  final emotionCounts = <String, int>{};
  for (final m in a.moods) {
    for (final e in m.emotions) {
      emotionCounts[e.key] = (emotionCounts[e.key] ?? 0) + 1;
    }
  }
  if (emotionCounts.isNotEmpty) {
    final top = emotionCounts.entries.toList()
      ..sort((x, y) => y.value.compareTo(x.value));
    summary.add(
      'emotions: ${top.take(3).map((e) => label(e.key)).join(', ')}',
    );
  }
  if (a.tasks.isNotEmpty) {
    final done = a.tasks.where((t) => t.done).length;
    summary.add('tasks $done/${a.tasks.length}');
  }
  if (summary.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('**${summary.join(' · ')}**');
  }

  // --- Mood -------------------------------------------------------------
  if (a.moods.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('### Mood');
    for (final m in a.moods) {
      final parts = <String>['${_dateTime(m.occurredAt)} — ${m.mood}/5'];
      if (m.emotions.isNotEmpty) {
        parts.add(
          m.emotions.map((e) => '${label(e.key)} (${e.intensity})').join(', '),
        );
      }
      final note = m.note?.trim();
      if (note != null && note.isNotEmpty) parts.add('"$note"');
      buffer.writeln('- ${parts.join(' — ')}');
    }
  }

  // --- Journal --------------------------------------------------------
  if (a.journals.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('### Journal');
    for (final j in a.journals) {
      final title = j.title?.trim();
      final head = title != null && title.isNotEmpty
          ? '${_date(j.createdAt)} — $title'
          : _date(j.createdAt);
      final firstLine = j.bodyMarkdown
          .trim()
          .split('\n')
          .firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
      buffer.writeln(
        firstLine.isEmpty ? '- $head' : '- $head — ${firstLine.trim()}',
      );
    }
  }

  // --- Tasks --------------------------------------------------------
  if (a.tasks.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('### Tasks');
    for (final t in a.tasks) {
      final box = t.done ? '[x]' : '[ ]';
      final note = t.closingNote?.trim();
      final suffix = note != null && note.isNotEmpty ? ' — $note' : '';
      buffer.writeln('- $box ${t.title}$suffix');
    }
  }

  return buffer.toString();
}
