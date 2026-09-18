import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/medication_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/repositories/thought_record_repository.dart';
import 'package:alveo/data/transfer/csv_export.dart';
import 'package:alveo/domain/cbt/cognitive_distortion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/domain/emotions/emotion_input.dart';

/// Minimal RFC 4180 reader, to check the writer against something independent.
List<List<String>> _parse(String csv) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var quoted = false;
  for (var i = 0; i < csv.length; i++) {
    final c = csv[i];
    if (quoted) {
      if (c == '"' && i + 1 < csv.length && csv[i + 1] == '"') {
        field.write('"');
        i++;
      } else if (c == '"') {
        quoted = false;
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      quoted = true;
    } else if (c == ',') {
      row.add(field.toString());
      field.clear();
    } else if (c == '\r') {
      // part of CRLF
    } else if (c == '\n') {
      row.add(field.toString());
      field.clear();
      rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
  }
  return rows;
}

void main() {
  test('escapes commas, quotes and line breaks', () {
    expect(csvField('plain'), 'plain');
    expect(csvField('a,b'), '"a,b"');
    expect(csvField('say "hi"'), '"say ""hi"""');
    expect(csvField('two\nlines'), '"two\nlines"');
  });

  test('neutralises spreadsheet formulas', () {
    expect(csvField('=1+1'), "'=1+1");
    // Spreadsheets skip a leading tab or CR before deciding, so these hide a
    // formula from a check that only looks at the first character.
    expect(csvField('\t=SUM(A1)'), "'\t=SUM(A1)");
    expect(csvField('\r=SUM(A1)'), '"\'\r=SUM(A1)"');
    expect(csvField('+54 11'), "'+54 11");
  });

  test('writes one readable row per record, under a header', () async {
    final db = AppDatabase.forTesting();
    addTearDown(db.close);
    await db.into(db.tags).insert(TagsCompanion.insert(id: 't', name: 'work'));
    await DriftMoodRepository(db).add(
      mood: 4,
      occurredAt: DateTime(2026, 8, 20, 9, 5),
      note: 'slept, finally',
      emotions: const [EmotionInput(emotionKey: 'joy', intensity: 3)],
      tagIds: ['t'],
    );
    await DriftJournalRepository(db).create(
      bodyMarkdown: 'line one\nline "two"',
      entryDate: DateTime(2026, 8, 21),
      title: 'Notes',
    );
    await DriftTaskRepository(db).create(title: 'Breathe');
    await DriftSessionRepository(db)
        .create(scheduledFor: DateTime(2026, 9, 1, 10), agendaMarkdown: 'prep');
    await DriftThoughtRecordRepository(db).create(
      occurredAt: DateTime(2026, 8, 22, 18),
      situation: 'meeting',
      automaticThought: 'they hate me',
      distortions: {CognitiveDistortion.allOrNothing},
    );
    final med = await DriftMedicationRepository(db)
        .create(name: 'Sertraline', dose: '50 mg');
    await DriftMedicationRepository(db)
        .logDose(med, takenAt: DateTime(2026, 8, 23, 8));

    final csv = await CsvExportService(db).exportToCsv();
    expect(csv.startsWith('﻿'), isTrue, reason: 'BOM for spreadsheets');
    final rows = _parse(csv.substring(1));

    expect(rows.first, csvHeader);
    final byType = {for (final r in rows.skip(1)) r[0]: r};
    expect(byType.keys, containsAll(csvRecordTypes));

    final mood = byType['check-in']!;
    expect(mood[1], '2026-08-20 09:05');
    expect(mood[2], '4/5');
    expect(mood[3], 'slept, finally');
    expect(mood[4], contains('joy 3'));
    expect(mood[4], contains('work'));

    expect(byType['journal']![3], 'line one\nline "two"');
    expect(byType['thought record']![4], contains('allOrNothing'));
    expect(byType['medication dose']![2], 'Sertraline');
  });
}
