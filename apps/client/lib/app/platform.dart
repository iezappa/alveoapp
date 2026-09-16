import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether this is the web build. A provider rather than [kIsWeb] directly,
/// so widget tests (which run natively) can check the web-only copy.
final isWebProvider = Provider<bool>((ref) => kIsWeb);
