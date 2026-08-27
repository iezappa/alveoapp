import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/repositories/journal_repository.dart';
import 'package:terapia/data/repositories/mood_repository.dart';
import 'package:terapia/data/repositories/task_repository.dart';
import 'package:terapia/data/search/search_service.dart';
import 'package:terapia/domain/search/search_hit.dart';

void main() {
  late AppDatabase db;
  late SearchService search;

  setUp(() {
    db = AppDatabase.forTesting();
    search = SearchService(db);
  });
  tearDown(() => db.close());

  test('finds matches across journal, task and mood, newest first', () async {
    await JournalRepository(db).create(
      bodyMarkdown: 'talked about boundaries with my sister',
      entryDate: DateTime(2026, 8, 10),
    );
    await TaskRepository(
      db,
    ).create(title: 'set boundaries at work', createdAt: DateTime(2026, 8, 20));
    await MoodRepository(db).add(
      mood: 3,
      occurredAt: DateTime(2026, 8, 5),
      note: 'no boundaries today',
    );
    await TaskRepository(db).create(title: 'unrelated');

    final hits = await search.search('boundaries', {});

    expect(hits, hasLength(3));
    expect(hits.first.type, SearchType.task); // 2026-08-20 is newest
    expect(hits.map((h) => h.type), contains(SearchType.journal));
    expect(hits.map((h) => h.type), contains(SearchType.mood));
  });

  test('the type filter narrows results', () async {
    await JournalRepository(db).create(
      bodyMarkdown: 'a note about sleep',
      entryDate: DateTime(2026, 8, 10),
    );
    await TaskRepository(db).create(title: 'track sleep');

    final onlyTasks = await search.search('sleep', {SearchType.task});
    expect(onlyTasks, hasLength(1));
    expect(onlyTasks.single.type, SearchType.task);
  });

  test('queries shorter than two characters return nothing', () async {
    await JournalRepository(db)
        .create(bodyMarkdown: 'aaa', entryDate: DateTime(2026, 8, 10));
    expect(await search.search('a', {}), isEmpty);
  });

  test('search is case-insensitive and builds an excerpt', () async {
    await JournalRepository(db).create(
      bodyMarkdown:
          'A long entry that mentions Resilience somewhere inside it.',
      entryDate: DateTime(2026, 8, 10),
    );

    final hits = await search.search('RESILIENCE', {SearchType.journal});
    expect(hits, hasLength(1));
    expect(hits.single.snippet.toLowerCase(), contains('resilience'));
  });
}
