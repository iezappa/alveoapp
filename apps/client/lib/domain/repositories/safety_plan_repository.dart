import '../safety/safety_plan.dart';

abstract interface class SafetyPlanRepository {
  Future<SafetyPlan> load();
  Future<void> save(SafetyPlan plan);
}
