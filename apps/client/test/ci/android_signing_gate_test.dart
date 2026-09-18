// The release-signing gate in android/app/build.gradle.kts refuses to build a
// release APK without android/key.properties. CI never has the keystore, so
// it builds debug only — which means nothing would notice if the gate were
// deleted or broke. ci.yml therefore asks Gradle to plan a release build and
// expects it to be refused with the gate's own message.
@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('CI checks that a release build without the keystore is refused', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    const message = 'Release signing is not configured';
    expect(gradle, contains(message), reason: 'the gate itself');

    final ci = loadYaml(
      File('../../.github/workflows/ci.yml').readAsStringSync(),
    ) as YamlMap;
    final runs = (ci['jobs']['build-android']['steps'] as YamlList)
        .map((step) => '${(step as YamlMap)['run'] ?? ''}')
        .where((run) => run.contains('assembleRelease'));

    expect(runs, hasLength(1));
    expect(runs.single, contains(message));
  });
}
