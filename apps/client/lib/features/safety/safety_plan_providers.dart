import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/safety/safety_plan.dart';

/// The saved safety plan. Invalidate after saving.
final safetyPlanProvider = FutureProvider<SafetyPlan>((ref) {
  return ref.watch(safetyPlanRepositoryProvider).load();
});
