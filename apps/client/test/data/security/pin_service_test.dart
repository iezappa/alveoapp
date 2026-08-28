import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/data/security/pin_service.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late PinService pin;

  setUp(() {
    db = AppDatabase.forTesting();
    settings = SettingsRepository(db);
    pin = PinService(settings);
  });
  tearDown(() => db.close());

  test('no PIN by default', () async {
    expect(await pin.hasPin(), isFalse);
    expect(await pin.verify('1234'), isFalse);
  });

  test('set then verify', () async {
    await pin.setPin('2468');
    expect(await pin.hasPin(), isTrue);
    expect(await pin.verify('2468'), isTrue);
    expect(await pin.verify('0000'), isFalse);
  });

  test('clear removes it', () async {
    await pin.setPin('2468');
    await pin.clearPin();
    expect(await pin.hasPin(), isFalse);
    expect(await pin.verify('2468'), isFalse);
  });

  test('the raw PIN is never stored', () async {
    await pin.setPin('9137');
    expect(await settings.get('security.pin_hash'), isNot(contains('9137')));
    expect(await settings.get('security.pin_salt'), isNotNull);
  });

  test('re-setting the same PIN produces a fresh salt', () async {
    await pin.setPin('1111');
    final salt1 = await settings.get('security.pin_salt');
    await pin.setPin('1111');
    final salt2 = await settings.get('security.pin_salt');
    expect(salt1, isNot(equals(salt2)));
  });
}
