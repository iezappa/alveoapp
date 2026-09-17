import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/obsidian/frontmatter.dart';
import 'package:alveo/data/obsidian/obsidian_service.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/domain/journal/journal_section.dart';

void main() {
  late AppDatabase db;
  late DriftJournalRepository journal;
  late ObsidianService obsidian;
  late Directory vault;

  setUp(() async {
    db = AppDatabase.forTesting();
    journal = DriftJournalRepository(db);
    obsidian = ObsidianService(journal);
    vault = await Directory.systemTemp.createTemp('alveo-vault-');
  });
  tearDown(() async {
    await db.close();
    if (vault.existsSync()) await vault.delete(recursive: true);
  });

  test('export writes one frontmattered file per entry', () async {
    await journal.create(
      bodyMarkdown: 'a poem',
      entryDate: DateTime(2026, 8, 20),
      title: 'Poem',
      section: JournalSection.creative,
      id: 'j1',
    );

    final report = await obsidian.exportJournal(vault.path);
    expect(report.exported, 1);

    final file = File('${vault.path}/Alveo/creative/2026-08-20-poem.md');
    expect(file.existsSync(), isTrue);
    final fm = parseFrontmatter(file.readAsStringSync());
    expect(fm.meta['alveo-id'], 'j1');
    expect(fm.meta['section'], 'creative');
    expect(fm.body.trim(), 'a poem');
  });

  test('round trip: export, edit the file, import updates the entry', () async {
    await journal.create(
      bodyMarkdown: 'first',
      entryDate: DateTime(2026, 8, 20),
      section: JournalSection.student,
      id: 'j1',
    );
    await obsidian.exportJournal(vault.path);

    final file = Directory('${vault.path}/Alveo/student')
        .listSync()
        .whereType<File>()
        .first;
    final fm = parseFrontmatter(file.readAsStringSync());
    file.writeAsStringSync(buildFrontmatter(fm.meta, 'edited in obsidian'));

    final report = await obsidian.importJournal(vault.path);
    expect(report.updated, 1);
    expect(
      (await journal.getById('j1'))!.bodyMarkdown.trim(),
      'edited in obsidian',
    );
  });

  test(
    'a plain note is imported once, then stamped so re-import updates',
    () async {
      final note = File('${vault.path}/idea.md')
        ..writeAsStringSync('# An idea\n\nsomething');

      final first = await obsidian.importJournal(vault.path);
      expect(first.created, 1);
      expect(await journal.getBySection(JournalSection.oneLiner), hasLength(1));
      expect(
        parseFrontmatter(note.readAsStringSync()).meta['alveo-id'],
        isNotNull,
      );

      final second = await obsidian.importJournal(vault.path);
      expect(second.created, 0);
      expect(second.updated, 1);
      expect(await journal.getBySection(JournalSection.oneLiner), hasLength(1));
    },
  );
}
