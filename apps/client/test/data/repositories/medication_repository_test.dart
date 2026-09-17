import 'package:flutter_test/flutter_test.dart';
import 'package:alveo/data/local/database.dart';
import 'package:alveo/data/repositories/medication_repository.dart';

void main() {
  late AppDatabase db;
  late DriftMedicationRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = DriftMedicationRepository(db);
  });
  tearDown(() => db.close());

  test('active meds sort before inactive ones', () async {
    final a = await repo.create(name: 'Zoloft', dose: '50mg');
    await repo.create(name: 'Melatonin');
    await repo.update(
      id: a,
      name: 'Zoloft',
      dose: '50mg',
      scheduleNote: null,
      active: false,
    );

    final all = await repo.getAll();
    expect(all.first.name, 'Melatonin'); // active first
    expect(all.last.name, 'Zoloft');
  });

  test('logs doses per day and cascades on delete', () async {
    final id = await repo.create(name: 'Melatonin');
    await repo.logDose(id, takenAt: DateTime(2026, 8, 28, 22));
    await repo.logDose(id, takenAt: DateTime(2026, 8, 28, 23));
    await repo.logDose(id, takenAt: DateTime(2026, 8, 27, 22));

    expect(await repo.dosesOn(id, DateTime(2026, 8, 28)), hasLength(2));
    expect(await repo.dosesOn(id, DateTime(2026, 8, 27)), hasLength(1));

    await repo.delete(id);
    expect(await repo.dosesOn(id, DateTime(2026, 8, 28)), isEmpty);
  });
}
