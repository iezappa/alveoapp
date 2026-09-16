import 'package:alveo/app/locale_controller.dart';
import 'package:alveo/app/theme_controller.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/journal_repository.dart';
import 'package:alveo/data/repositories/link_repository.dart';
import 'package:alveo/data/repositories/mood_repository.dart';
import 'package:alveo/data/repositories/session_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/repositories/task_repository.dart';
import 'package:alveo/data/security/pin_service.dart';
import 'package:alveo/data/transfer/data_eraser.dart';
import 'package:alveo/domain/links/link_target_type.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _populate(AppDatabase db) async {
  await db
      .into(db.tags)
      .insert(TagsCompanion.insert(id: 'tag-work', name: 'work'));
  await MoodRepository(db).add(
    mood: 4,
    occurredAt: DateTime(2026, 8, 20, 9),
    emotions: const [EmotionInput(emotionKey: 'joy', intensity: 3)],
    tagIds: ['tag-work'],
    id: 'mood-1',
  );
  await JournalRepository(db).create(
    bodyMarkdown: '# hi',
    entryDate: DateTime(2026, 8, 20),
    emotions: const [EmotionInput(emotionKey: 'fear', intensity: 2)],
    tagIds: ['tag-work'],
    id: 'jrnl-1',
  );
  await TaskRepository(db).create(title: 'Breathe', id: 'task-1');
  await SessionRepository(db)
      .create(scheduledFor: DateTime(2026, 9, 1, 10), id: 'sess-1');
  await LinkRepository(db).link('sess-1', LinkTargetType.task, 'task-1');
}

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late DataEraser eraser;

  setUp(() async {
    db = AppDatabase.forTesting();
    settings = SettingsRepository(db);
    eraser = DataEraser(db);
    await db.customSelect('SELECT 1').get(); // foreign keys on
  });
  tearDown(() => db.close());

  group('holdsUserData', () {
    test('is false on a fresh install', () async {
      expect(await eraser.holdsUserData(), isFalse);
    });

    test('is true once anything is written', () async {
      await TaskRepository(db).create(title: 'Breathe');
      expect(await eraser.holdsUserData(), isTrue);
    });

    test('ignores preferences alone', () async {
      await settings.set(localeSettingKey, 'es');
      expect(await eraser.holdsUserData(), isFalse);
    });
  });

  group('eraseEverything', () {
    test('empties every table, children and parents alike', () async {
      await _populate(db);

      await eraser.eraseEverything();

      for (final table in db.allTables) {
        if (table.actualTableName == db.appSettings.actualTableName) continue;
        final count = await db
            .customSelect('SELECT COUNT(*) AS c FROM ${table.actualTableName}')
            .getSingle();
        expect(count.read<int>('c'), 0, reason: table.actualTableName);
      }
    });

    test('clears the PIN, the profile and the flags', () async {
      await PinService(settings).setPin('1234');
      await settings.set('profile.name', 'Ana');
      await settings.set('onboarding.tutorial_seen', 'true');
      await settings.set('safety.plan', '{}');

      await eraser.eraseEverything();

      expect(await PinService(settings).hasPin(), isFalse);
      expect(await settings.get('profile.name'), isNull);
      expect(await settings.get('onboarding.tutorial_seen'), isNull);
      expect(await settings.get('safety.plan'), isNull);
    });

    test('keeps only the language and the appearance', () async {
      await settings.set(localeSettingKey, 'es');
      await settings.set(ThemeController.modeKey, 'dark');
      await settings.set(ThemeController.accentKey, 'blue');

      await eraser.eraseEverything();

      expect(await settings.get(localeSettingKey), 'es');
      expect(await settings.get(ThemeController.modeKey), 'dark');
      expect(await settings.get(ThemeController.accentKey), 'blue');
    });
  });
}
