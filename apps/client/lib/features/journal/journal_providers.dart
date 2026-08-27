import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../domain/journal/journal_section.dart';

/// All journal entries, newest first. Invalidate after a create/update.
final journalListProvider = FutureProvider<List<JournalEntry>>((ref) {
  return ref.watch(journalRepositoryProvider).getAll();
});

/// Entries in one section, newest first.
final journalSectionEntriesProvider =
    FutureProvider.family<List<JournalEntry>, JournalSection>((ref, section) {
      return ref.watch(journalRepositoryProvider).getBySection(section);
    });

/// A single journal entry by id (null while editing a brand-new one).
final journalEntryProvider = FutureProvider.family<JournalEntry?, String>((
  ref,
  id,
) {
  return ref.watch(journalRepositoryProvider).getById(id);
});
