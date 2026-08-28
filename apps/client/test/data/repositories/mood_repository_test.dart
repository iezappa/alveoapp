import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/tag_repository.dart';

void main() {
  late AppDatabase db;
  late MoodRepository mood;
  late TagRepository tags;

  setUp(() {
    db = AppDatabase.forTesting();
    mood = MoodRepository(db);
    tags = TagRepository(db);
  });
  tearDown(() => db.close());

  test('update rewrites score, note, emotions and tags', () async {
    final workId = await tags.findOrCreate('work');
    final id = await mood.add(
      mood: 2,
      occurredAt: DateTime(2026, 8, 20),
      note: 'meh',
      emotions: const [EmotionInput(emotionKey: 'fear', intensity: 3)],
      tagIds: [workId],
    );

    final sleepId = await tags.findOrCreate('sleep');
    await mood.update(
      id: id,
      mood: 4,
      note: 'better after a nap',
      emotions: const [EmotionInput(emotionKey: 'joy', intensity: 2)],
      tagIds: [sleepId],
    );

    final entry = await mood.getById(id);
    expect(entry!.mood, 4);
    expect(entry.note, 'better after a nap');
    expect((await mood.emotionsFor(id)).single.emotionKey, 'joy');
    expect((await mood.tagsFor(id)).map((t) => t.name), ['sleep']);
  });

  test('findOrCreate reuses a tag by case-insensitive name', () async {
    final a = await tags.findOrCreate('Work');
    final b = await tags.findOrCreate('  work  ');
    expect(a, b);
    expect((await tags.all()).map((t) => t.name), ['Work']);
  });
}
