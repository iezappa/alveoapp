import '../../data/local/database.dart';

abstract interface class MedicationRepository {
  Future<String> create({
    required String name,
    String? dose,
    String? scheduleNote,
    String? id,
  });

  Future<void> update({
    required String id,
    required String name,
    String? dose,
    String? scheduleNote,
    required bool active,
  });

  Future<List<Medication>> getAll();
  Future<Medication?> getById(String id);
  Future<void> delete(String id);
  Future<void> logDose(String medicationId, {DateTime? takenAt});
  Future<List<MedicationLog>> dosesOn(String medicationId, DateTime day);
  Future<void> deleteDose(String doseId);
}
