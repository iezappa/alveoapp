import '../release_notes/app_version.dart';

/// A version newer than the one running, and how to get it.
class UpdateInfo {
  const UpdateInfo({
    required this.latest,
    required this.url,
    this.androidUrl,
    this.notes,
    this.schemaChange = false,
    this.minSupportedVersion,
  });

  final AppVersion latest;

  /// Where to send the user: the release page, or a reload on the web.
  final Uri url;

  /// The APK asset, when the release carries one.
  final Uri? androidUrl;

  final String? notes;

  /// True when the release changes the local schema: the banner then asks
  /// for a backup before updating.
  final bool schemaChange;

  /// Oldest version the migration to [latest] is tested from.
  final AppVersion? minSupportedVersion;
}

/// Looks for a newer version. Never throws: being offline is a normal day.
abstract interface class UpdateService {
  /// Null when there is nothing new, no network, or the throttle says wait.
  Future<UpdateInfo?> check();
}
