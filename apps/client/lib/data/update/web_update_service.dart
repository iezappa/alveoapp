import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/release_notes/app_version.dart';
import '../../domain/update/update_info.dart';
import 'update_check_problem.dart';

/// On the web the build itself says which version it is (`version.json`), and
/// the service worker knows when a newer one is already installed and
/// waiting. Either is a new version.
class WebUpdateService implements UpdateService {
  WebUpdateService({
    required this.installed,
    required this.client,
    required this.baseUri,
    required this.hasWaitingWorker,
    this.timeout = const Duration(seconds: 5),
    this.onProblem = reportUpdateCheckProblem,
  });

  final AppVersion installed;
  final http.Client client;

  /// Where the app is served from, so the request follows the base href.
  final Uri baseUri;

  /// Whether sw.js has a new version installed and waiting.
  final Future<bool> Function() hasWaitingWorker;

  final Duration timeout;

  /// Told when the server answered with something this app cannot read.
  final UpdateCheckProblemReporter onProblem;

  @override
  Future<UpdateInfo?> check() async {
    AppVersion? published;
    var schemaChange = false;
    AppVersion? minSupported;
    // Cache-busted: same origin, so there is no rate limit to respect.
    final stamp = DateTime.now().millisecondsSinceEpoch;
    // Offline is normal and says nothing; an answer that arrived and cannot
    // be read is reported. Either way whatever the worker knows still counts.
    final version = await _fetch('version.json?t=$stamp');
    if (version != null) {
      try {
        published = AppVersion.tryParse(
          (jsonDecode(version) as Map)['version'] as String?,
        );
        if (published == null) {
          throw const FormatException('no readable "version"');
        }
      } on Object catch (error) {
        onProblem('version.json', error);
      }
    }
    final meta = version == null ? null : await _fetch('update.json?t=$stamp');
    if (meta != null) {
      try {
        final data = (jsonDecode(meta) as Map).cast<String, dynamic>();
        schemaChange = data['schemaChange'] == true;
        minSupported = AppVersion.tryParse(
          data['minSupportedVersion'] as String?,
        );
      } on Object catch (error) {
        onProblem('update.json', error);
      }
    }

    var waiting = false;
    try {
      waiting = await hasWaitingWorker();
    } on Object {
      waiting = false;
    }

    final newer = published != null && published > installed;
    if (!newer && !waiting) return null;

    return UpdateInfo(
      latest: newer ? published : installed,
      url: baseUri,
      schemaChange: schemaChange,
      minSupportedVersion: minSupported,
    );
  }

  /// The body at [path], or null when it did not arrive: offline, a timeout
  /// or a non-200 answer, none of which is worth reporting.
  Future<String?> _fetch(String path) async {
    try {
      final response = await client.get(baseUri.resolve(path)).timeout(timeout);
      return response.statusCode == 200 ? response.body : null;
    } on Object {
      return null;
    }
  }
}
