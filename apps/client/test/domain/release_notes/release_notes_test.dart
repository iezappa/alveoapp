import 'dart:io';

import 'package:alveo/domain/release_notes/app_version.dart';
import 'package:alveo/domain/release_notes/release_notes.dart';
import 'package:flutter_test/flutter_test.dart';

const _json = '''
{"releases": [
  {"version": "1.0.0", "date": "2026-09-01", "highlights": ["first"]},
  {"version": "1.1.0", "date": "2026-09-10", "highlights": ["second"]}
]}
''';

void main() {
  test('sorts newest first and knows the current version', () {
    final notes = ReleaseNotes.parse(_json);
    expect(notes.current, const AppVersion(1, 1, 0));
    expect(notes.all.last.highlights, ['first']);
  });

  test('rejects a changelog with nothing to say', () {
    expect(() => ReleaseNotes.parse('{"releases": []}'), throwsFormatException);
    expect(() => ReleaseNotes.parse('nope'), throwsFormatException);
  });

  group('toAnnounce', () {
    final notes = ReleaseNotes.parse(_json);
    test('a first install announces nothing', () {
      expect(notes.toAnnounce(null), isEmpty);
    });
    test('an update announces only what came after', () {
      expect(notes.toAnnounce(const AppVersion(1, 0, 0)).single.highlights, [
        'second',
      ]);
    });
    test('the same version announces nothing', () {
      expect(notes.toAnnounce(const AppVersion(1, 1, 0)), isEmpty);
    });
  });

  test('the shipped changelogs parse and match the pubspec version', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = AppVersion.tryParse(
      RegExp(r'^version:\s*(\S+)', multiLine: true).firstMatch(pubspec)![1],
    );
    for (final lang in ['en', 'es']) {
      final notes = ReleaseNotes.parse(
        File('assets/release_notes/$lang.json').readAsStringSync(),
      );
      expect(notes.current, version, reason: lang);
    }
    expect(pubspec, contains('assets/release_notes/'));
  });
}
