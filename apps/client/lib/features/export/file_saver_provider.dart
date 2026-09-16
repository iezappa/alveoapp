import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_saver.dart';

/// Writes text to a file the user chooses; returns where, or null if cancelled.
typedef TextFileSaver = Future<String?> Function({
  required String suggestedName,
  required String contents,
  required String typeLabel,
  required List<String> extensions,
});

/// The platform save dialog (or browser download), overridable in tests.
final textFileSaverProvider = Provider<TextFileSaver>((ref) => saveTextFile);
