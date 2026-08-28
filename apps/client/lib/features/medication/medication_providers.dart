import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';

/// All medications, active first. Invalidate after a create/update/dose.
final medicationListProvider = FutureProvider<List<Medication>>((ref) {
  return ref.watch(medicationRepositoryProvider).getAll();
});

final medicationByIdProvider = Provider.family<Medication?, String>((ref, id) {
  final meds =
      ref.watch(medicationListProvider).asData?.value ??
      const <Medication>[];
  for (final m in meds) {
    if (m.id == id) return m;
  }
  return null;
});

/// How many doses of [id] were logged today.
final dosesTodayProvider = FutureProvider.family<int, String>((ref, id) async {
  ref.watch(medicationListProvider); // refresh alongside the list
  final rows = await ref
      .read(medicationRepositoryProvider)
      .dosesOn(id, DateTime.now());
  return rows.length;
});
