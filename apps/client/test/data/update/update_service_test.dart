import 'package:alveo/data/update/github_update_service.dart';
import 'package:alveo/data/update/update_throttle.dart';
import 'package:alveo/data/update/web_update_service.dart';
import 'package:alveo/domain/release_notes/app_version.dart';
import 'package:alveo/domain/update/update_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _installed = AppVersion(1, 0, 0);

void main() {
  group('throttle', () {
    test('asks when it has never asked', () {
      expect(
        shouldCheckForUpdate(lastCheck: null, now: DateTime(2026)),
        isTrue,
      );
    });
    test('does not ask again within six hours', () {
      expect(
        shouldCheckForUpdate(
          lastCheck: DateTime(2026, 1, 1, 0),
          now: DateTime(2026, 1, 1, 5),
        ),
        isFalse,
      );
    });
    test('asks again after six hours', () {
      expect(
        shouldCheckForUpdate(
          lastCheck: DateTime(2026, 1, 1, 0),
          now: DateTime(2026, 1, 1, 7),
        ),
        isTrue,
      );
    });
  });

  group('GitHub releases', () {
    Future<UpdateInfo?> check(MockClient client) => GitHubUpdateService(
      installed: _installed,
      client: client,
      repository: 'iezappa/alveoapp',
    ).check();

    test('reports a newer tag, with the APK asset as the target', () async {
      final info = await check(
        MockClient(
          (request) async => http.Response('''
{"tag_name":"v1.2.0","html_url":"https://github.com/iezappa/alveoapp/releases/v1.2.0",
 "body":"notes here",
 "assets":[{"name":"alveoapp-v1.2.0-android.apk",
            "browser_download_url":"https://example.test/alveoapp.apk"},
           {"name":"update.json",
            "browser_download_url":"https://example.test/update.json"}]}
''', 200),
        ),
      );

      expect(info!.latest, const AppVersion(1, 2, 0));
      expect(info.notes, 'notes here');
      expect(info.androidUrl, Uri.parse('https://example.test/alveoapp.apk'));
      expect(info.schemaChange, isFalse);
    });

    test('says nothing when the release is the installed version', () async {
      final info = await check(
        MockClient((_) async => http.Response('{"tag_name":"v1.0.0"}', 200)),
      );
      expect(info, isNull);
    });

    test('swallows a network failure', () async {
      final info = await check(
        MockClient((_) async => throw const SocketExceptionStub()),
      );
      expect(info, isNull);
    });

    test('reads schemaChange from the update.json asset', () async {
      final info = await GitHubUpdateService(
        installed: _installed,
        repository: 'iezappa/alveoapp',
        client: MockClient((request) async {
          if (request.url.path.endsWith('update.json')) {
            return http.Response(
              '{"version":"1.2.0","schemaChange":true,'
              '"minSupportedVersion":"0.9.0"}',
              200,
            );
          }
          return http.Response('''
{"tag_name":"v1.2.0","assets":[{"name":"update.json",
 "browser_download_url":"https://example.test/update.json"}]}
''', 200);
        }),
      ).check();

      expect(info!.schemaChange, isTrue);
      expect(info.minSupportedVersion, const AppVersion(0, 9, 0));
    });
    group('tells a broken answer apart from no answer', () {
      Future<List<String>> problemsFor(MockClient client) async {
        final problems = <String>[];
        await GitHubUpdateService(
          installed: _installed,
          client: client,
          repository: 'iezappa/alveoapp',
          onProblem: (what, _) => problems.add(what),
        ).check();
        return problems;
      }

      test('reports a body that is not JSON', () async {
        expect(
          await problemsFor(
            MockClient((_) async => http.Response('<html>oops</html>', 200)),
          ),
          hasLength(1),
        );
      });

      test('reports a tag it cannot read', () async {
        expect(
          await problemsFor(
            MockClient(
              (_) async => http.Response('{"tag_name":"release-7"}', 200),
            ),
          ),
          hasLength(1),
        );
      });

      test('does not report being offline or an HTTP error', () async {
        expect(
          await problemsFor(
            MockClient((_) async => throw const SocketExceptionStub()),
          ),
          isEmpty,
        );
        expect(
          await problemsFor(MockClient((_) async => http.Response('', 503))),
          isEmpty,
        );
      });
    });
  });

  group('web', () {
    test('compares version.json against the running build', () async {
      final info = await WebUpdateService(
        installed: _installed,
        client: MockClient(
          (_) async => http.Response('{"version":"1.1.0"}', 200),
        ),
        baseUri: Uri.parse('/alveoapp/'),
        hasWaitingWorker: () async => false,
      ).check();

      expect(info!.latest, const AppVersion(1, 1, 0));
    });

    test('a waiting service worker is a new version too', () async {
      final info = await WebUpdateService(
        installed: _installed,
        client: MockClient(
          (_) async => http.Response('{"version":"1.0.0"}', 200),
        ),
        baseUri: Uri.parse('/alveoapp/'),
        hasWaitingWorker: () async => true,
      ).check();

      expect(info, isNotNull);
    });

    test('nothing waiting and nothing newer means no update', () async {
      final info = await WebUpdateService(
        installed: _installed,
        client: MockClient(
          (_) async => http.Response('{"version":"1.0.0"}', 200),
        ),
        baseUri: Uri.parse('/alveoapp/'),
        hasWaitingWorker: () async => false,
      ).check();

      expect(info, isNull);
    });
    test(
      'reports an unreadable version.json but still honours the worker',
      () async {
        final problems = <String>[];
        final info = await WebUpdateService(
          installed: _installed,
          client: MockClient((_) async => http.Response('<html>', 200)),
          baseUri: Uri.parse('/alveoapp/'),
          hasWaitingWorker: () async => true,
          onProblem: (what, _) => problems.add(what),
        ).check();

        expect(problems, contains('version.json'));
        expect(info, isNotNull);
      },
    );

    test('does not report being offline', () async {
      final problems = <String>[];
      await WebUpdateService(
        installed: _installed,
        client: MockClient((_) async => throw const SocketExceptionStub()),
        baseUri: Uri.parse('/alveoapp/'),
        hasWaitingWorker: () async => false,
        onProblem: (what, _) => problems.add(what),
      ).check();

      expect(problems, isEmpty);
    });
  });
}

class SocketExceptionStub implements Exception {
  const SocketExceptionStub();
}
