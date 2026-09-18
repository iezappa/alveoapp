import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/release_notes/app_version.dart';
import '../../domain/update/update_info.dart';
import 'update_check_problem.dart';

/// Asks GitHub Releases what the newest version is (Android, Windows, Linux,
/// macOS). Unauthenticated — never embed a token in the app.
class GitHubUpdateService implements UpdateService {
  GitHubUpdateService({
    required this.installed,
    required this.repository,
    required this.client,
    this.timeout = const Duration(seconds: 5),
    this.onProblem = reportUpdateCheckProblem,
  });

  final AppVersion installed;
  final String repository;
  final http.Client client;
  final Duration timeout;

  /// Told when GitHub answered with something this app cannot read.
  final UpdateCheckProblemReporter onProblem;

  @override
  Future<UpdateInfo?> check() async {
    // Not reaching GitHub is normal and fixes itself; an answer this app
    // cannot read does not. Only the second is reported — the user sees the
    // same silence either way.
    final http.Response response;
    try {
      response = await client
          .get(
            Uri.parse(
              'https://api.github.com/repos/$repository/releases/latest',
            ),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(timeout);
    } on Object {
      return null; // No connection is a normal case, not an error.
    }
    if (response.statusCode != 200) return null;

    final Map<String, dynamic> release;
    final AppVersion latest;
    try {
      release = jsonDecode(response.body) as Map<String, dynamic>;
      final tag = AppVersion.tryParse(release['tag_name'] as String?);
      if (tag == null) {
        throw FormatException('unreadable tag_name', release['tag_name']);
      }
      latest = tag;
    } on Object catch (error) {
      onProblem('the GitHub release', error);
      return null;
    }
    if (!(latest > installed)) return null;

    try {
      final assets = (release['assets'] as List? ?? const [])
          .whereType<Map>()
          .toList();
      Uri? assetNamed(bool Function(String name) matches) {
        for (final asset in assets) {
          final name = '${asset['name']}';
          if (matches(name)) {
            return Uri.tryParse('${asset['browser_download_url']}');
          }
        }
        return null;
      }

      final metadata = await _metadata(assetNamed((n) => n == 'update.json'));

      return UpdateInfo(
        latest: latest,
        url: Uri.parse(
          '${release['html_url'] ?? 'https://github.com/$repository/releases/latest'}',
        ),
        androidUrl: assetNamed((n) => n.endsWith('-android.apk')),
        notes: release['body'] as String?,
        schemaChange: metadata['schemaChange'] == true,
        minSupportedVersion: AppVersion.tryParse(
          metadata['minSupportedVersion'] as String?,
        ),
      );
    } on Object catch (error) {
      onProblem('the GitHub release', error);
      return null;
    }
  }

  /// The release's `update.json`, or an empty map: a release without one is
  /// assumed not to change the schema.
  Future<Map<String, dynamic>> _metadata(Uri? url) async {
    if (url == null) return const {};
    try {
      final response = await client.get(url).timeout(timeout);
      if (response.statusCode != 200) return const {};
      return (jsonDecode(response.body) as Map).cast<String, dynamic>();
    } on Object {
      return const {};
    }
  }
}
