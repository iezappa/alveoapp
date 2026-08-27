import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/timeline/timeline_item.dart';

/// The merged, newest-first activity feed. Invalidate it after writing a
/// record so the timeline refetches.
final timelineProvider = FutureProvider<List<TimelineItem>>((ref) {
  return ref.watch(timelineRepositoryProvider).getTimeline();
});
