import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The release workflow, the signing script, the compose file and the README
/// all name the same artifacts. When they drift apart, someone downloads a
/// file that does not exist.
void main() {
  final release = File('../../.github/workflows/release.yml')
      .readAsStringSync();
  final readme = File('../../README.md').readAsStringSync();
  final compose = File('../../deploy/docker-compose.yml').readAsStringSync();
  final script = File('tool/release_apk.sh').readAsStringSync();

  test('the release workflow builds every platform the repo has', () {
    for (final platform in ['linux', 'windows', 'macos', 'web-pages']) {
      expect(release, contains('  $platform:'));
      if (platform != 'web-pages') {
        expect(Directory(platform).existsSync(), isTrue);
      }
    }
    // Android is built and signed locally, never in CI (docs/SIGNING.md).
    expect(release, isNot(contains('flutter build apk')));
  });

  test('the APK name is the same in the script and the README', () {
    expect(script, contains('APK_BASENAME="alveoapp"'));
    expect(readme, contains('alveoapp-vX.Y.Z-android.apk'));
  });

  test('the README names the archives the workflow produces', () {
    for (final suffix in ['linux-x64.tar.gz', 'windows-x64.zip', 'macos.zip']) {
      expect(release, contains(suffix));
      expect(readme, contains('alveoapp-vX.Y.Z-$suffix'));
    }
  });

  test('the image is the one the compose file and the docs pull', () {
    expect(release, contains(r'ghcr.io/${{ github.repository }}'));
    expect(compose, contains('ghcr.io/iezappa/alveoapp:latest'));
    expect(
      File('../../deploy/ZIMAOS.md').readAsStringSync(),
      contains('ghcr.io/iezappa/alveoapp'),
    );
  });

  test('the compose file is filled in, with no placeholders left', () {
    expect(compose, isNot(contains(r'${APP_NAME}')));
    expect(compose, isNot(contains('{{')));
    expect(compose, contains('8083'));
    expect(compose, contains('Zeke Zappa Developments (iezappa)'));
  });

  test('version-check guards the version and the legal documents', () {
    expect(release, contains('version-check'));
    expect(release, contains('PRIVACY.md'));
    expect(release, contains('TERMS.md'));
    expect(release, contains('TRACKING_ALLOWLIST'));
  });

  test('the update metadata the workflow checks ships with the app', () {
    final update = File('web/update.json').readAsStringSync();
    final version = RegExp(
      r'^version:\s*(\d+\.\d+\.\d+)',
      multiLine: true,
    ).firstMatch(File('pubspec.yaml').readAsStringSync())![1]!;
    expect(update, contains('"version": "$version"'));
  });
}
