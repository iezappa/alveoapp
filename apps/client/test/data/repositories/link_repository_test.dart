import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/repositories/journal_repository.dart';
import 'package:terapia/data/repositories/link_repository.dart';
import 'package:terapia/data/repositories/session_repository.dart';
import 'package:terapia/data/repositories/task_repository.dart';
import 'package:terapia/domain/links/link_target_type.dart';

void main() {
  late AppDatabase db;
  late LinkRepository links;
  late SessionRepository sessions;
  late TaskRepository tasks;
  late JournalRepository journals;

  setUp(() {
    db = AppDatabase.forTesting();
    links = LinkRepository(db);
    sessions = SessionRepository(db);
    tasks = TaskRepository(db);
    journals = JournalRepository(db);
  });
  tearDown(() => db.close());

  test('link then read resolved items', () async {
    final s = await sessions.create(scheduledFor: DateTime(2026, 9, 1));
    final t = await tasks.create(title: 'Breathe');
    final j = await journals.create(
      bodyMarkdown: 'x',
      entryDate: DateTime(2026, 8, 30),
      title: 'Notes',
    );

    await links.link(s, LinkTargetType.task, t);
    await links.link(s, LinkTargetType.journal, j);

    final items = await links.linkedItems(s);
    expect(
      items.map((i) => i.type),
      containsAll([LinkTargetType.task, LinkTargetType.journal]),
    );
    expect(
      items.firstWhere((i) => i.type == LinkTargetType.task).title,
      'Breathe',
    );
  });

  test('linking the same record twice is idempotent', () async {
    final s = await sessions.create(scheduledFor: DateTime(2026, 9, 1));
    final t = await tasks.create(title: 'Breathe');

    await links.link(s, LinkTargetType.task, t);
    await links.link(s, LinkTargetType.task, t);

    expect(await links.linkedItems(s), hasLength(1));
  });

  test('dangling links are skipped on read and cleaned by removeLinksTo',
      () async {
    final s = await sessions.create(scheduledFor: DateTime(2026, 9, 1));
    final t = await tasks.create(title: 'Breathe');
    await links.link(s, LinkTargetType.task, t);

    await tasks.delete(t);
    expect(await links.linkedItems(s), isEmpty);

    await links.removeLinksTo(LinkTargetType.task, t);
    expect(await db.select(db.sessionLinks).get(), isEmpty);
  });

  test('linkableItems excludes already-linked records', () async {
    final s = await sessions.create(scheduledFor: DateTime(2026, 9, 1));
    final t1 = await tasks.create(title: 'A');
    final t2 = await tasks.create(title: 'B');
    await links.link(s, LinkTargetType.task, t1);

    final candidates = await links.linkableItems(s);
    expect(candidates.map((i) => i.id), contains(t2));
    expect(candidates.map((i) => i.id), isNot(contains(t1)));
  });

  test('unlink removes the association', () async {
    final s = await sessions.create(scheduledFor: DateTime(2026, 9, 1));
    final t = await tasks.create(title: 'Breathe');
    await links.link(s, LinkTargetType.task, t);

    await links.unlink(s, LinkTargetType.task, t);

    expect(await links.linkedItems(s), isEmpty);
  });

  test('deleting a session cascades its links', () async {
    final s = await sessions.create(scheduledFor: DateTime(2026, 9, 1));
    final t = await tasks.create(title: 'Breathe');
    await links.link(s, LinkTargetType.task, t);

    await sessions.delete(s);

    expect(await db.select(db.sessionLinks).get(), isEmpty);
  });
}
