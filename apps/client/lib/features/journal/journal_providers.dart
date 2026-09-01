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

/// Emotion keys attached to a journal entry.
final journalEmotionsProvider = FutureProvider.family<List<String>, String>((
  ref,
  id,
) async {
  ref.watch(journalListProvider); // refresh alongside the entry list
  final rows = await ref.read(journalRepositoryProvider).emotionsFor(id);
  return rows.map((e) => e.emotionKey).toList();
});

/// One entry by id, resolved from [journalListProvider] so it refreshes with
/// the same invalidation. `null` while the list loads or if the id is gone.
final journalEntryByIdProvider = Provider.family<JournalEntry?, String>((
  ref,
  id,
) {
  final entries =
      ref.watch(journalListProvider).asData?.value ?? const <JournalEntry>[];
  for (final entry in entries) {
    if (entry.id == id) return entry;
  }
  return null;
});
