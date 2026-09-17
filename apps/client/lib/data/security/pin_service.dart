import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../domain/repositories/settings_repository.dart';

/// App-launch PIN gate.
///
/// The PIN is stored only as a salted, iterated SHA-256 digest. Be honest
/// about the threat model: a 4-8 digit PIN has a tiny keyspace, so this
/// resists casual inspection of the database file, NOT an offline brute-force.
/// Real at-rest protection needs an encrypted database (SQLCipher) and is a
/// separate, later piece of work.
class PinService {
  PinService(this._settings);

  final SettingsRepository _settings;

  static const _saltKey = 'security.pin_salt';
  static const _hashKey = 'security.pin_hash';
  static const _iterations = 20000;
  static const minLength = 4;

  Future<bool> hasPin() async => (await _settings.get(_hashKey)) != null;

  Future<void> setPin(String pin) async {
    final salt = _randomBytes(16);
    final hash = _derive(pin, salt);
    await _settings.set(_saltKey, base64Encode(salt));
    await _settings.set(_hashKey, base64Encode(hash));
  }

  Future<bool> verify(String pin) async {
    final saltB64 = await _settings.get(_saltKey);
    final hashB64 = await _settings.get(_hashKey);
    if (saltB64 == null || hashB64 == null) return false;

    final computed = _derive(pin, base64Decode(saltB64));
    return _constantTimeEquals(computed, base64Decode(hashB64));
  }

  Future<void> clearPin() async {
    await _settings.remove(_saltKey);
    await _settings.remove(_hashKey);
  }

  List<int> _derive(String pin, List<int> salt) {
    var bytes = sha256.convert([...salt, ...utf8.encode(pin)]).bytes;
    for (var i = 1; i < _iterations; i++) {
      bytes = sha256.convert([...salt, ...bytes]).bytes;
    }
    return bytes;
  }

  Uint8List _randomBytes(int n) {
    final rng = Random.secure();
    return Uint8List.fromList(List.generate(n, (_) => rng.nextInt(256)));
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
