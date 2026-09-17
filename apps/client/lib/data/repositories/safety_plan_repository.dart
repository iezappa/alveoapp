import '../../domain/safety/safety_plan.dart';
import '../../domain/repositories/safety_plan_repository.dart';
import '../../domain/repositories/settings_repository.dart';

/// Persists the single [SafetyPlan] as a JSON blob in app settings.
class DriftSafetyPlanRepository implements SafetyPlanRepository {
  DriftSafetyPlanRepository(this._settings);

  final SettingsRepository _settings;

  static const _key = 'safety.plan';

  @override
  Future<SafetyPlan> load() async =>
      SafetyPlan.decode(await _settings.get(_key));

  @override
  Future<void> save(SafetyPlan plan) => _settings.set(_key, plan.encode());
}
