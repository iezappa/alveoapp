import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/repositories/session_repository.dart';

void main() {
  late AppDatabase db;
  late SessionRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = SessionRepository(db);
  });
  tearDown(() => db.close());

  test('create then read back', () async {
    final id = await repo.create(
      scheduledFor: DateTime(2026, 9, 1, 10),
      agendaMarkdown: '- boundaries',
    );

    final session = await repo.getById(id);
    expect(session, isNotNull);
    expect(session!.scheduledFor, DateTime(2026, 9, 1, 10));
    expect(session.agendaMarkdown, '- boundaries');
    expect(session.notesMarkdown, isNull);
  });

  test('update overwrites the bodies and the scheduled time', () async {
    final id = await repo.create(scheduledFor: DateTime(2026, 9, 1, 10));

    await repo.update(
      id: id,
      scheduledFor: DateTime(2026, 9, 2, 9),
      notesMarkdown: 'talked about work',
      takeawaysMarkdown: 'try the breathing exercise',
    );

    final session = await repo.getById(id);
    expect(session!.scheduledFor, DateTime(2026, 9, 2, 9));
    expect(session.notesMarkdown, 'talked about work');
    expect(session.takeawaysMarkdown, 'try the breathing exercise');
  });

  test('previousBefore and nextFrom pick the right neighbours', () async {
    await repo.create(scheduledFor: DateTime(2026, 8, 1, 10), id: 'a');
    await repo.create(scheduledFor: DateTime(2026, 8, 15, 10), id: 'b');
    await repo.create(scheduledFor: DateTime(2026, 9, 1, 10), id: 'c');

    expect((await repo.previousBefore(DateTime(2026, 8, 20)))!.id, 'b');
    expect((await repo.nextFrom(DateTime(2026, 8, 20)))!.id, 'c');
    expect(await repo.previousBefore(DateTime(2026, 7, 1)), isNull);
  });
}
