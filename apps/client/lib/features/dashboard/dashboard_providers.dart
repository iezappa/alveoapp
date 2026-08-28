import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../sessions/session_providers.dart';

/// The next session scheduled at or after now, or `null` when none is.
///
/// Derived from [sessionListProvider] (ascending by `scheduledFor`) so it
/// picks up the same invalidation the session editor already triggers.
final nextSessionProvider = Provider<AsyncValue<Session?>>((ref) {
  final now = DateTime.now();
  return ref.watch(sessionListProvider).whenData((sessions) {
    for (final session in sessions) {
      if (!session.scheduledFor.isBefore(now)) return session;
    }
    return null;
  });
});
