import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The PWA has to open offline, and Flutter's own worker no longer caches
/// anything (§8.2). These check the pieces are shipped and that the
/// generator really fills them in.
void main() {
  test('the bootstrap loads Flutter without serviceWorkerSettings', () {
    final bootstrap = File('web/flutter_bootstrap.js').readAsStringSync();
    // load() is called with no arguments: passing serviceWorkerSettings is
    // what lets Flutter's stub worker replace ours.
    expect(bootstrap, contains('_flutter.loader.load();'));
    expect(
      RegExp(r'load\(\s*\{').hasMatch(bootstrap),
      isFalse,
      reason: 'load() must take no options',
    );
    expect(bootstrap, contains('appServiceWorker'));
    // Registered relative, so the scope is the folder it is served from.
    expect(bootstrap, contains("register('sw.js'"));
  });

  test('the worker ships with placeholders and waits for the user', () {
    final sw = File('web/sw.js').readAsStringSync();
    expect(sw, contains("const APP_VERSION = '__APP_VERSION__'"));
    expect(sw, contains('/*__PRECACHE_MANIFEST__*/'));
    // skipWaiting only when the app asks: a new version waits for the user
    // instead of swapping code under a running page.
    final skip = sw.indexOf('self.skipWaiting()');
    expect(skip, greaterThan(0));
    expect(sw.substring(0, skip), contains('SKIP_WAITING'));
    expect(File('web/sw-killswitch.js').existsSync(), isTrue);
  });

  test('generate_sw.sh injects the version and a manifest with hashes', () {
    final dir = Directory.systemTemp.createTempSync('sw');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/sw.js')
        .writeAsStringSync(File('web/sw.js').readAsStringSync());
    File('${dir.path}/main.dart.js').writeAsStringSync('console.log(1)');
    File('${dir.path}/version.json').writeAsStringSync('{}');

    final run = Process.runSync('sh', [
      'tool/generate_sw.sh',
      dir.path,
      'pubspec.yaml',
    ]);
    expect(run.exitCode, 0, reason: '${run.stderr}');

    final generated = File('${dir.path}/sw.js').readAsStringSync();
    final version = RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(File('pubspec.yaml').readAsStringSync())![1]!;
    expect(generated, contains("const APP_VERSION = '$version'"));
    expect(generated, contains('"url":"main.dart.js"'));
    expect(generated, isNot(contains('/*__PRECACHE_MANIFEST__*/ []')));
    // Network-only files are never precached: UpdateService must see them
    // fresh.
    expect(generated, isNot(contains('"url":"version.json"')));
  });

  test('the killswitch only unregisters and clears its own caches', () {
    final kill = File('web/sw-killswitch.js').readAsStringSync();
    expect(kill, contains('unregister'));
    expect(kill, contains('caches'));
  });
}
