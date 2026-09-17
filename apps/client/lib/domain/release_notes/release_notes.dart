import 'dart:convert';

import 'app_version.dart';

class ReleaseNote {
  const ReleaseNote({
    required this.version,
    required this.date,
    required this.highlights,
  });

  final AppVersion version;
  final DateTime date;
  final List<String> highlights;
}

/// The changelog that ships inside the app, newest release first.
///
/// It is compiled in with the code that reads it, so a malformed file is a
/// build mistake: parsing throws, and a test parses the shipped files.
class ReleaseNotes {
  const ReleaseNotes._(this.all);

  factory ReleaseNotes.parse(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw FormatException('The changelog is not JSON: ${e.message}');
    }
    final releases = decoded is Map ? decoded['releases'] : null;
    if (releases is! List || releases.isEmpty) {
      throw const FormatException('The changelog declares no releases');
    }
    final notes = [
      for (final r in releases)
        if (r is Map &&
            AppVersion.tryParse(r['version'] as String?) != null &&
            DateTime.tryParse('${r['date']}') != null &&
            r['highlights'] is List &&
            (r['highlights'] as List).isNotEmpty)
          ReleaseNote(
            version: AppVersion.tryParse(r['version'] as String)!,
            date: DateTime.parse('${r['date']}'),
            highlights: [for (final h in r['highlights'] as List) '$h'],
          )
        else
          throw FormatException('Unreadable release: $r'),
    ]..sort((a, b) => b.version.compareTo(a.version));
    return ReleaseNotes._(List.unmodifiable(notes));
  }

  final List<ReleaseNote> all;

  /// The version of this build: the newest entry.
  AppVersion get current => all.first.version;

  /// What to show on launch. A first install ([lastSeen] null) is told
  /// nothing — it was never around for these releases.
  List<ReleaseNote> toAnnounce(AppVersion? lastSeen) => lastSeen == null
      ? const []
      : all.where((n) => n.version > lastSeen).toList();
}
