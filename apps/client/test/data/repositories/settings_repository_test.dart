import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/data/local/database.dart';
import 'package:terapia/data/repositories/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;

  setUp(() {
    db = AppDatabase.forTesting();
    settings = SettingsRepository(db);
  });
  tearDown(() => db.close());

  test('returns null for an unknown key', () async {
    expect(await settings.get('missing'), isNull);
  });

  test('set then get round-trips, and a second set overwrites', () async {
    await settings.set('ui.locale', 'es');
    expect(await settings.get('ui.locale'), 'es');

    await settings.set('ui.locale', 'en');
    expect(await settings.get('ui.locale'), 'en');
  });

  test('remove deletes the key', () async {
    await settings.set('ui.locale', 'es');
    await settings.remove('ui.locale');
    expect(await settings.get('ui.locale'), isNull);
  });
}
