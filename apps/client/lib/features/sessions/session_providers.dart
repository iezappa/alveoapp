import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';

/// All sessions in chronological order. Invalidate after a create/update.
final sessionListProvider = FutureProvider<List<Session>>((ref) {
  return ref.watch(sessionRepositoryProvider).getAll();
});

/// One session by id, resolved from [sessionListProvider] so it refreshes with
/// the same invalidation. `null` while the list loads or if the id is gone.
final sessionByIdProvider = Provider.family<Session?, String>((ref, id) {
  final sessions =
      ref.watch(sessionListProvider).asData?.value ?? const <Session>[];
  for (final session in sessions) {
    if (session.id == id) return session;
  }
  return null;
});
