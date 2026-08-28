import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/safety_plan_repository.dart';
import 'package:alveo/data/repositories/settings_repository.dart';
import 'package:alveo/domain/safety/safety_plan.dart';

void main() {
  late AppDatabase db;
  late SafetyPlanRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = SafetyPlanRepository(SettingsRepository(db));
  });
  tearDown(() => db.close());

  test('starts empty, then saves and reloads', () async {
    expect((await repo.load()).isEmpty, isTrue);

    await repo.save(
      const SafetyPlan(
        warningSigns: 'shutting down',
        contacts: [SafetyContact(name: 'Mum', phone: '555')],
      ),
    );

    final loaded = await repo.load();
    expect(loaded.warningSigns, 'shutting down');
    expect(loaded.contacts.single.name, 'Mum');
  });
}
