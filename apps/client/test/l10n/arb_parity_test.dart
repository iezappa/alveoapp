import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:terapia/domain/emotions/plutchik.dart';

void main() {
  Map<String, dynamic> loadArb(String path) =>
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

  Set<String> messageKeys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  test('every ARB locale defines the same message keys', () {
    final en = loadArb('lib/l10n/app_en.arb');
    final es = loadArb('lib/l10n/app_es.arb');
    expect(messageKeys(es), equals(messageKeys(en)));
  });

  test('each Plutchik emotion has a non-empty label in every locale', () {
    for (final path in ['lib/l10n/app_en.arb', 'lib/l10n/app_es.arb']) {
      final arb = loadArb(path);
      for (final e in plutchikPrimaryEmotions) {
        final key = 'emotion${e.key[0].toUpperCase()}${e.key.substring(1)}';
        expect(arb.containsKey(key), isTrue, reason: '$path missing $key');
        expect((arb[key] as String).trim(), isNotEmpty);
      }
    }
  });
}
