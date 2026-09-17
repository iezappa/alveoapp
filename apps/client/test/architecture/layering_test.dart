import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The hinge of §1.1: screens and their providers know the repository
/// interfaces, never the database. If this fails, moving off local-first
/// storage would mean rewriting screens, not swapping an implementation.
void main() {
  final presentation = Directory('lib/features')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('there is presentation code to check', () {
    expect(presentation, isNotEmpty);
  });

  test('no screen imports drift', () {
    final offenders = [
      for (final file in presentation)
        if (file.readAsStringSync().contains("import 'package:drift/"))
          file.path,
    ];
    expect(offenders, isEmpty);
  });

  test('no screen imports a Drift repository implementation', () {
    final offenders = [
      for (final file in presentation)
        if (RegExp(r"import .*data/repositories/")
            .hasMatch(file.readAsStringSync()))
          file.path,
    ];
    expect(offenders, isEmpty);
  });

  test('every repository provider is typed as the domain interface', () {
    final providers = File('lib/data/providers.dart').readAsStringSync();
    final declared = RegExp(r'Provider<(\w+Repository)>')
        .allMatches(providers)
        .map((m) => m[1]!)
        .toSet();
    expect(declared, isNotEmpty);
    for (final name in declared) {
      expect(name, isNot(startsWith('Drift')), reason: providers);
    }
    // And each one is built by a Drift implementation of that interface.
    for (final name in declared) {
      expect(providers, contains('Drift$name('));
    }
  });
}
