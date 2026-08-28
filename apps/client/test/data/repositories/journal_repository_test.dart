import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/domain/journal/journal_section.dart';

void main() {
  late AppDatabase db;
  late JournalRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = JournalRepository(db);
  });
  tearDown(() => db.close());

  test('create defaults to the one-liner section', () async {
    final id = await repo.create(
      bodyMarkdown: 'today was fine',
      entryDate: DateTime(2026, 8, 20),
    );
    final entry = await repo.getById(id);
    expect(entry!.section, JournalSection.oneLiner);
    expect(entry.isMonthlyReview, isFalse);
  });

  test('getBySection returns only that section, newest first', () async {
    await repo.create(
      bodyMarkdown: 'a',
      entryDate: DateTime(2026, 8, 1),
      section: JournalSection.creative,
    );
    await repo.create(
      bodyMarkdown: 'b',
      entryDate: DateTime(2026, 8, 10),
      section: JournalSection.creative,
    );
    await repo.create(
      bodyMarkdown: 'c',
      entryDate: DateTime(2026, 8, 5),
      section: JournalSection.student,
    );

    final creative = await repo.getBySection(JournalSection.creative);
    expect(creative.map((e) => e.bodyMarkdown), ['b', 'a']);
    expect(await repo.getBySection(JournalSection.student), hasLength(1));
  });

  test('getMonthlyReview finds the review filed in that month', () async {
    await repo.create(bodyMarkdown: 'line', entryDate: DateTime(2026, 8, 12));
    final reviewId = await repo.create(
      bodyMarkdown: 'August was hard but ok',
      entryDate: DateTime(2026, 8, 1),
      isMonthlyReview: true,
    );

    final found = await repo.getMonthlyReview(DateTime(2026, 8, 20));
    expect(found?.id, reviewId);
    expect(await repo.getMonthlyReview(DateTime(2026, 9, 1)), isNull);
  });
}
