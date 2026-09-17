import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether this is the web build. A provider rather than [kIsWeb] directly,
/// so widget tests (which run natively) can check the web-only copy.
final isWebProvider = Provider<bool>((ref) => kIsWeb);

/// Whether Obsidian sync can run: it reads and writes a vault folder through
/// the filesystem, which the web has not got and Android only exposes through
/// the Storage Access Framework.
final supportsObsidianProvider = Provider<bool>(
  (ref) =>
      !ref.watch(isWebProvider) &&
      defaultTargetPlatform != TargetPlatform.android,
);
