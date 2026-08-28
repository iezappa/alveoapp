import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../domain/cbt/cognitive_distortion.dart';

/// All thought records, most recent first. Invalidate after a create/update.
final thoughtRecordListProvider = FutureProvider<List<ThoughtRecord>>((ref) {
  return ref.watch(thoughtRecordRepositoryProvider).getAll();
});

/// One record by id, resolved from [thoughtRecordListProvider].
final thoughtRecordByIdProvider = Provider.family<ThoughtRecord?, String>((
  ref,
  id,
) {
  final records =
      ref.watch(thoughtRecordListProvider).asData?.value ??
      const <ThoughtRecord>[];
  for (final r in records) {
    if (r.id == id) return r;
  }
  return null;
});

/// The distortions tagged on a record.
final thoughtRecordDistortionsProvider =
    FutureProvider.family<Set<CognitiveDistortion>, String>((ref, id) {
      ref.watch(thoughtRecordListProvider); // refresh alongside the list
      return ref.read(thoughtRecordRepositoryProvider).distortionsFor(id);
    });
