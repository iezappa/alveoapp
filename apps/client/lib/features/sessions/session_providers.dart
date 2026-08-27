import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';

/// All sessions in chronological order. Invalidate after a create/update.
final sessionListProvider = FutureProvider<List<Session>>((ref) {
  return ref.watch(sessionRepositoryProvider).getAll();
});
