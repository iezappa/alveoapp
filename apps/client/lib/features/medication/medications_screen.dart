import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import 'medication_providers.dart';
import '../shared/save_failure.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final meds = ref.watch(medicationListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicationsTitle)),
      body: meds.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.medication_outlined,
              message: l10n.medicationsEmpty,
            );
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: kGutter,
                  vertical: 8,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (context, i) => _MedicationTile(med: items[i]),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/medications/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.newMedication),
      ),
    );
  }
}

class _MedicationTile extends ConsumerWidget {
  const _MedicationTile({required this.med});

  final Medication med;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final doses = ref.watch(dosesTodayProvider(med.id)).asData?.value ?? 0;

    final subtitleParts = <String>[
      if ((med.dose ?? '').trim().isNotEmpty) med.dose!.trim(),
      if ((med.scheduleNote ?? '').trim().isNotEmpty) med.scheduleNote!.trim(),
    ];

    return ListTile(
      title: Text(
        med.name,
        style: med.active
            ? null
            : TextStyle(
                decoration: TextDecoration.lineThrough,
                color: scheme.onSurfaceVariant,
              ),
      ),
      subtitle: subtitleParts.isEmpty
          ? null
          : Text(subtitleParts.join('  ·  ')),
      trailing: med.active
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (doses > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      l10n.medicationTakenToday(doses),
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ),
                IconButton.filledTonal(
                  onPressed: () async {
                    final logged = await saveOrReport(
                      context,
                      () => ref
                          .read(medicationRepositoryProvider)
                          .logDose(med.id),
                    );
                    if (logged) ref.invalidate(medicationListProvider);
                  },
                  icon: const Icon(Icons.add),
                  tooltip: l10n.medicationTake,
                ),
              ],
            )
          : null,
      onTap: () => context.push('/medications/${med.id}'),
    );
  }
}
