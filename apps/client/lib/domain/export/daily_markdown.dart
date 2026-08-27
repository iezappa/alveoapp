/// Pure, framework-free rendering of one day's records to a Markdown document
/// with YAML frontmatter. This is the source format the doctor-facing PDF
/// (Fase 4) is built from later, so it must stay stable and lossless for the
/// journal body.
library;

class DayEmotion {
  const DayEmotion({required this.key, required this.intensity});

  final String key;
  final int intensity;
}

class DayMoodEntry {
  const DayMoodEntry({
    required this.occurredAt,
    required this.mood,
    this.note,
    this.emotions = const [],
  });

  final DateTime occurredAt;
  final int mood;
  final String? note;
  final List<DayEmotion> emotions;
}

class DayJournalEntry {
  const DayJournalEntry({
    required this.createdAt,
    required this.bodyMarkdown,
    this.title,
  });

  final DateTime createdAt;
  final String bodyMarkdown;
  final String? title;
}

class DayTask {
  const DayTask({required this.title, required this.done, this.closingNote});

  final String title;
  final bool done;
  final String? closingNote;
}

class DailyExport {
  const DailyExport({
    required this.day,
    this.moods = const [],
    this.journals = const [],
    this.tasks = const [],
  });

  final DateTime day;
  final List<DayMoodEntry> moods;
  final List<DayJournalEntry> journals;
  final List<DayTask> tasks;

  bool get isEmpty => moods.isEmpty && journals.isEmpty && tasks.isEmpty;
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String _hhmm(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

/// Renders [data] to a Markdown string. [emotionLabel] maps an emotion key to
/// a display name; when omitted the raw key is used.
String renderDailyMarkdown(
  DailyExport data, {
  String Function(String emotionKey)? emotionLabel,
}) {
  String label(String key) => emotionLabel?.call(key) ?? key;

  final buffer = StringBuffer();

  // --- Frontmatter -----------------------------------------------------------
  final emotionKeys = <String>{
    for (final m in data.moods)
      for (final e in m.emotions) e.key,
  }.toList();
  final doneCount = data.tasks.where((t) => t.done).length;

  buffer.writeln('---');
  buffer.writeln('date: ${_isoDate(data.day)}');
  if (data.moods.isNotEmpty) {
    final avg =
        data.moods.map((m) => m.mood).reduce((a, b) => a + b) /
        data.moods.length;
    buffer.writeln('mood_avg: ${_trimNumber(avg)}');
  }
  if (emotionKeys.isNotEmpty) {
    buffer.writeln('emotions: [${emotionKeys.join(', ')}]');
  }
  if (data.tasks.isNotEmpty) {
    buffer.writeln('tasks_completed: $doneCount/${data.tasks.length}');
  }
  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('# ${_isoDate(data.day)}');

  if (data.isEmpty) {
    buffer.writeln();
    buffer.writeln('_No records for this day._');
    return buffer.toString();
  }

  // --- Mood ----------------------------------------------------------------
  if (data.moods.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('## Mood');
    for (final m in data.moods) {
      buffer.writeln();
      buffer.writeln('### ${_hhmm(m.occurredAt)} — ${m.mood}/5');
      if (m.emotions.isNotEmpty) {
        final parts = m.emotions
            .map((e) => '${label(e.key)} (${e.intensity})')
            .join(', ');
        buffer.writeln();
        buffer.writeln('Emotions: $parts');
      }
      if (m.note != null && m.note!.trim().isNotEmpty) {
        buffer.writeln();
        buffer.writeln(m.note!.trim());
      }
    }
  }

  // --- Journal -----------------------------------------------------------
  if (data.journals.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('## Journal');
    for (final j in data.journals) {
      buffer.writeln();
      final heading = j.title?.trim().isNotEmpty ?? false
          ? '${_hhmm(j.createdAt)} — ${j.title!.trim()}'
          : _hhmm(j.createdAt);
      buffer.writeln('### $heading');
      buffer.writeln();
      buffer.writeln(j.bodyMarkdown.trimRight());
    }
  }

  // --- Tasks -----------------------------------------------------------
  if (data.tasks.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('## Tasks');
    buffer.writeln();
    for (final t in data.tasks) {
      final box = t.done ? '[x]' : '[ ]';
      final note = t.closingNote?.trim().isNotEmpty ?? false
          ? ' — ${t.closingNote!.trim()}'
          : '';
      buffer.writeln('- $box ${t.title}$note');
    }
  }

  return buffer.toString();
}

String _trimNumber(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
