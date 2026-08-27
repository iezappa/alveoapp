import 'dart:io';

import '../../domain/journal/journal_section.dart';
import '../../domain/obsidian/obsidian_report.dart';
import '../local/database.dart';
import '../repositories/journal_repository.dart';
import 'frontmatter.dart';

/// Two-way bridge between the app's journal and a folder of Markdown files
/// (an Obsidian vault, or a subfolder of one).
///
/// Journal entries only — sessions, tasks and mood are structured records and
/// stay out of the vault. Matching is by a `terapia-id` frontmatter field;
/// export writes it and import writes it back into plain notes so the next
/// round trip updates instead of duplicating. There is no merge: export
/// overwrites the file from the app, import overwrites the entry from the file.
class ObsidianService {
  ObsidianService(this._journal);

  final JournalRepository _journal;

  static const _subfolder = 'Terapia';

  /// Writes every journal entry into `<vaultDir>/Terapia/<section>/…md`,
  /// reusing an existing file when its `terapia-id` matches.
  Future<ObsidianReport> exportJournal(String vaultDir) async {
    final base = Directory('$vaultDir${Platform.pathSeparator}$_subfolder');
    final existing = _indexById(base);

    final entries = await _journal.getAll();
    for (final entry in entries) {
      final sectionDir = Directory(
        '${base.path}${Platform.pathSeparator}${entry.section.name}',
      )..createSync(recursive: true);

      final file =
          existing[entry.id] ??
          File(
            '${sectionDir.path}${Platform.pathSeparator}'
            '${_isoDate(entry.entryDate)}-${_slug(_titleOf(entry))}.md',
          );

      file.writeAsStringSync(
        buildFrontmatter(_metaFor(entry), entry.bodyMarkdown),
      );
    }

    return ObsidianReport(exported: entries.length);
  }

  /// Reads every `.md` under [dir] and merges it into the journal.
  Future<ObsidianReport> importJournal(String dir) async {
    final root = Directory(dir);
    if (!root.existsSync()) {
      throw const ObsidianException('The folder no longer exists.');
    }

    var created = 0;
    var updated = 0;
    var skipped = 0;

    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || !entity.path.toLowerCase().endsWith('.md')) {
        continue;
      }
      final parsed = parseFrontmatter(entity.readAsStringSync());
      if (parsed.body.trim().isEmpty) {
        skipped++;
        continue;
      }

      final id = parsed.meta['terapia-id'];
      final title = _clean(parsed.meta['title']);
      final section = _sectionFor(parsed.meta['section'], entity, dir);
      final date = _parseDate(parsed.meta['date']) ?? entity.lastModifiedSync();
      final isReview = parsed.meta['monthly-review'] == 'true';

      if (id != null) {
        final local = await _journal.getById(id);
        if (local != null) {
          await _journal.updateBody(
            id: id,
            bodyMarkdown: parsed.body,
            title: title,
          );
          updated++;
        } else {
          await _journal.create(
            id: id,
            bodyMarkdown: parsed.body,
            entryDate: date,
            title: title,
            section: section,
            isMonthlyReview: isReview,
          );
          created++;
        }
        continue;
      }

      // A note written directly in Obsidian: create it, then stamp the file
      // with its new id so the next import updates rather than duplicates.
      final newId = await _journal.create(
        bodyMarkdown: parsed.body,
        entryDate: date,
        title: title ?? _titleFromBody(parsed.body) ?? _basename(entity),
        section: section,
      );
      final created0 = await _journal.getById(newId);
      if (created0 != null) {
        entity.writeAsStringSync(
          buildFrontmatter(_metaFor(created0), parsed.body),
        );
      }
      created++;
    }

    return ObsidianReport(created: created, updated: updated, skipped: skipped);
  }

  Map<String, File> _indexById(Directory base) {
    final map = <String, File>{};
    if (!base.existsSync()) return map;
    for (final entity in base.listSync(recursive: true)) {
      if (entity is! File || !entity.path.toLowerCase().endsWith('.md')) {
        continue;
      }
      final id = parseFrontmatter(entity.readAsStringSync()).meta['terapia-id'];
      if (id != null) map[id] = entity;
    }
    return map;
  }

  Map<String, String> _metaFor(JournalEntry entry) => {
    'terapia-id': entry.id,
    'terapia-type': 'journal',
    'section': entry.section.name,
    'date': _isoDate(entry.entryDate),
    if (_clean(entry.title) != null) 'title': _clean(entry.title)!,
    if (entry.isMonthlyReview) 'monthly-review': 'true',
    'updated': entry.updatedAt.toIso8601String(),
  };

  String _titleOf(JournalEntry entry) =>
      _clean(entry.title) ?? _titleFromBody(entry.bodyMarkdown) ?? 'entry';

  JournalSection _sectionFor(String? name, File file, String root) {
    final byName = JournalSection.values.where((s) => s.name == name).toList();
    if (byName.isNotEmpty) return byName.first;

    final parent = file.parent.path
        .replaceFirst(root, '')
        .split(Platform.pathSeparator)
        .where((p) => p.isNotEmpty)
        .toList();
    for (final segment in parent.reversed) {
      final match = JournalSection.values
          .where((s) => s.name.toLowerCase() == segment.toLowerCase())
          .toList();
      if (match.isNotEmpty) return match.first;
    }
    return JournalSection.oneLiner;
  }

  String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  String? _titleFromBody(String body) {
    final heading = RegExp(
      r'^#{1,6}\s+(.+)$',
      multiLine: true,
    ).firstMatch(body);
    return heading?.group(1)?.trim();
  }

  String _basename(File file) => file.uri.pathSegments.last.replaceAll(
    RegExp(r'\.md$', caseSensitive: false),
    '',
  );

  DateTime? _parseDate(String? value) =>
      value == null ? null : DateTime.tryParse(value);

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String _slug(String text) {
    final s = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return s.isEmpty ? 'entry' : (s.length <= 60 ? s : s.substring(0, 60));
  }
}
