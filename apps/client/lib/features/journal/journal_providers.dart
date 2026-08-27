import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';

/// All journal entries, newest first. Invalidate after a create/update.
final journalListProvider = FutureProvider<List<JournalEntry>>((ref) {
  return ref.watch(journalRepositoryProvider).getAll();
});

/// A single journal entry by id (null while editing a brand-new one).
final journalEntryProvider = FutureProvider.family<JournalEntry?, String>((
  ref,
  id,
) {
  return ref.watch(journalRepositoryProvider).getById(id);
});
