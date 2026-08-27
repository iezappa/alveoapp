import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/links/linked_item.dart';

/// Records currently linked to a session. Invalidate after link/unlink.
final sessionLinkedItemsProvider =
    FutureProvider.family<List<LinkedItem>, String>((ref, sessionId) {
      return ref.watch(linkRepositoryProvider).linkedItems(sessionId);
    });

/// Records available to link to a session (not already linked).
final sessionLinkableItemsProvider =
    FutureProvider.family<List<LinkedItem>, String>((ref, sessionId) {
      return ref.watch(linkRepositoryProvider).linkableItems(sessionId);
    });
