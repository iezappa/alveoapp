import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class MedicationRepository {
  MedicationRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  Future<String> create({
    required String name,
    String? dose,
    String? scheduleNote,
    String? id,
  }) async {
    final medId = id ?? _uuid.v4();
    await _db
        .into(_db.medications)
        .insert(
          MedicationsCompanion.insert(
            id: medId,
            name: name,
            dose: Value(dose),
            scheduleNote: Value(scheduleNote),
          ),
        );
    return medId;
  }

  Future<void> update({
    required String id,
    required String name,
    String? dose,
    String? scheduleNote,
    required bool active,
  }) {
    return (_db.update(_db.medications)..where((t) => t.id.equals(id))).write(
      MedicationsCompanion(
        name: Value(name),
        dose: Value(dose),
        scheduleNote: Value(scheduleNote),
        active: Value(active),
      ),
    );
  }

  /// Active meds first, then by name.
  Future<List<Medication>> getAll() {
    return (_db.select(_db.medications)..orderBy([
          (t) => OrderingTerm.desc(t.active),
          (t) => OrderingTerm.asc(t.name),
        ]))
        .get();
  }

  Future<Medication?> getById(String id) {
    return (_db.select(
      _db.medications,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.medications)..where((t) => t.id.equals(id))).go();
  }

  Future<void> logDose(String medicationId, {DateTime? takenAt}) {
    return _db
        .into(_db.medicationLogs)
        .insert(
          MedicationLogsCompanion.insert(
            id: _uuid.v4(),
            medicationId: medicationId,
            takenAt: takenAt ?? DateTime.now(),
          ),
        );
  }

  /// Doses of [medicationId] recorded on [day] (date part only), newest first.
  Future<List<MedicationLog>> dosesOn(String medicationId, DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.medicationLogs)
          ..where(
            (t) =>
                t.medicationId.equals(medicationId) &
                t.takenAt.isBiggerOrEqualValue(start) &
                t.takenAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]))
        .get();
  }

  Future<void> deleteDose(String doseId) {
    return (_db.delete(
      _db.medicationLogs,
    )..where((t) => t.id.equals(doseId))).go();
  }
}
