import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/release_notes/app_version.dart';
import '../../domain/update/update_info.dart';

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
  });

  final AppVersion installed;
  final http.Client client;

  /// Where the app is served from, so the request follows the base href.
  final Uri baseUri;

  /// Whether sw.js has a new version installed and waiting.
  final Future<bool> Function() hasWaitingWorker;

  final Duration timeout;

  @override
  Future<UpdateInfo?> check() async {
    AppVersion? published;
    var schemaChange = false;
    AppVersion? minSupported;
    try {
      // Cache-busted: same origin, so there is no rate limit to respect.
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final response = await client
          .get(baseUri.resolve('version.json?t=$stamp'))
          .timeout(timeout);
      if (response.statusCode == 200) {
        published = AppVersion.tryParse(
          (jsonDecode(response.body) as Map)['version'] as String?,
        );
      }
      final meta = await client
          .get(baseUri.resolve('update.json?t=$stamp'))
          .timeout(timeout);
      if (meta.statusCode == 200) {
        final data = (jsonDecode(meta.body) as Map).cast<String, dynamic>();
        schemaChange = data['schemaChange'] == true;
        minSupported = AppVersion.tryParse(
          data['minSupportedVersion'] as String?,
        );
      }
    } on Object {
      // Offline: whatever the worker knows still counts.
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
}
