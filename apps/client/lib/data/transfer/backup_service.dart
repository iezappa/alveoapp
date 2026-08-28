import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/transfer/import_report.dart';
import '../local/database.dart';

/// Full-database export/import for moving between devices.
///
/// Import is an additive merge keyed by primary key: a record whose id already
/// exists is skipped (never overwritten). Because every table uses a UUID
/// primary key, importing the same backup twice is a no-op. `app_settings`
/// (UI language, PIN) is intentionally excluded — it is device-local.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const _format = 'alveo-export';
  static const _formatVersion = 1;

  Future<String> exportToJson() async {
    Future<List<Map<String, dynamic>>> dump(TableInfo table) async {
      final rows = await _db
          .customSelect('SELECT * FROM ${table.actualTableName}')
          .get();
      return rows.map((r) => r.data).toList();
    }

    final bundle = {
      'format': _format,
      'version': _formatVersion,
      'schemaVersion': _db.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'data': {
        'tags': await dump(_db.tags),
        'sessions': await dump(_db.sessions),
        'moodEntries': await dump(_db.moodEntries),
        'journalEntries': await dump(_db.journalEntries),
        'tasks': await dump(_db.tasks),
        'moodEntryEmotions': await dump(_db.moodEntryEmotions),
        'journalEntryEmotions': await dump(_db.journalEntryEmotions),
        'moodEntryTags': await dump(_db.moodEntryTags),
        'journalEntryTags': await dump(_db.journalEntryTags),
        'sessionLinks': await dump(_db.sessionLinks),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(bundle);
  }

  Future<ImportReport> importFromJson(String source) async {
    final Map<String, dynamic> bundle;
    try {
      bundle = jsonDecode(source) as Map<String, dynamic>;
    } catch (_) {
      throw const ImportException('The file is not valid JSON.');
    }

    if (bundle['format'] != _format) {
      throw const ImportException('This is not an Alveo backup file.');
    }
    final fileSchema = bundle['schemaVersion'];
    if (fileSchema is int && fileSchema > _db.schemaVersion) {
      throw const ImportException(
        'This backup was made by a newer version of the app.',
      );
    }

    final data = ((bundle['data'] as Map?) ?? const {}).cast<String, dynamic>();
    List<Map<String, dynamic>> rows(String key) =>
        ((data[key] as List?) ?? const [])
            .map((e) => (e as Map).cast<String, dynamic>())
            .toList();

    final report = <String, TableImport>{};

    // Tags first, reconciling by name: two devices can create the same tag
    // name under different ids, so remap the incoming id onto the local one.
    final localTags = await _db.select(_db.tags).get();
    final localTagIdByName = {for (final t in localTags) t.name: t.id};
    final localTagIds = {for (final t in localTags) t.id};
    final tagRemap = <String, String>{};
    var tagsInserted = 0;
    var tagsSkipped = 0;

    for (final row in rows('tags')) {
      final id = row['id'] as String;
      final name = row['name'] as String;
      if (localTagIds.contains(id)) {
        tagsSkipped++;
        continue;
      }
      final sameName = localTagIdByName[name];
      if (sameName != null) {
        tagRemap[id] = sameName;
        tagsSkipped++;
        continue;
      }
      await _db
          .into(_db.tags)
          .insert(
            TagsCompanion.insert(id: id, name: name),
            mode: InsertMode.insertOrIgnore,
          );
      tagsInserted++;
    }
    report['tags'] = TableImport(inserted: tagsInserted, skipped: tagsSkipped);

    String remapTagId(String id) => tagRemap[id] ?? id;

    // Parents before children so foreign keys resolve (each merge commits).
    report['sessions'] = await _merge(_db.sessions, rows('sessions'));
    report['moodEntries'] = await _merge(_db.moodEntries, rows('moodEntries'));
    report['journalEntries'] = await _merge(
      _db.journalEntries,
      rows('journalEntries'),
    );
    report['tasks'] = await _merge(_db.tasks, rows('tasks'));
    report['moodEntryEmotions'] = await _merge(
      _db.moodEntryEmotions,
      rows('moodEntryEmotions'),
    );
    report['journalEntryEmotions'] = await _merge(
      _db.journalEntryEmotions,
      rows('journalEntryEmotions'),
    );
    report['moodEntryTags'] = await _merge(
      _db.moodEntryTags,
      rows('moodEntryTags')
          .map((r) => {...r, 'tag_id': remapTagId(r['tag_id'] as String)})
          .toList(),
    );
    report['journalEntryTags'] = await _merge(
      _db.journalEntryTags,
      rows('journalEntryTags')
          .map((r) => {...r, 'tag_id': remapTagId(r['tag_id'] as String)})
          .toList(),
    );
    report['sessionLinks'] = await _merge(
      _db.sessionLinks,
      rows('sessionLinks'),
    );

    return ImportReport(report);
  }

  /// Inserts [jsonRows] (raw column maps) into [table], ignoring rows whose
  /// primary key already exists. Counts inserted vs skipped by row delta.
  Future<TableImport> _merge(
    TableInfo table,
    List<Map<String, dynamic>> jsonRows,
  ) async {
    if (jsonRows.isEmpty) {
      return const TableImport(inserted: 0, skipped: 0);
    }

    final name = table.actualTableName;
    final before = await _countRows(name);

    for (final row in jsonRows) {
      final columns = row.keys.join(', ');
      final placeholders = List.filled(row.length, '?').join(', ');
      await _db.customInsert(
        'INSERT OR IGNORE INTO $name ($columns) VALUES ($placeholders)',
        variables: [for (final value in row.values) Variable(value)],
      );
    }

    final after = await _countRows(name);
    final inserted = after - before;
    return TableImport(inserted: inserted, skipped: jsonRows.length - inserted);
  }

  Future<int> _countRows(String tableName) async {
    final row = await _db
        .customSelect('SELECT COUNT(*) AS c FROM $tableName')
        .getSingle();
    return row.read<int>('c');
  }
}
