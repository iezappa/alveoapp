import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../shared/confirm_delete.dart';
import 'medication_providers.dart';

class MedicationEditorScreen extends ConsumerStatefulWidget {
  const MedicationEditorScreen({super.key, this.medicationId});

  final String? medicationId;

  bool get isNew => medicationId == null;

  @override
  ConsumerState<MedicationEditorScreen> createState() =>
      _MedicationEditorScreenState();
}

class _MedicationEditorScreenState
    extends ConsumerState<MedicationEditorScreen> {
  final _name = TextEditingController();
  final _dose = TextEditingController();
  final _schedule = TextEditingController();
  bool _active = true;
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.medicationId;
    if (id != null) {
      _loading = true;
      Future.microtask(() async {
        final med = await ref.read(medicationRepositoryProvider).getById(id);
        if (!mounted) return;
        setState(() {
          if (med != null) {
            _name.text = med.name;
            _dose.text = med.dose ?? '';
            _schedule.text = med.scheduleNote ?? '';
            _active = med.active;
          }
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    _schedule.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(medicationRepositoryProvider);
    String? textOrNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    if (widget.medicationId == null) {
      await repo.create(
        name: _name.text.trim(),
        dose: textOrNull(_dose),
        scheduleNote: textOrNull(_schedule),
      );
    } else {
      await repo.update(
        id: widget.medicationId!,
        name: _name.text.trim(),
        dose: textOrNull(_dose),
        scheduleNote: textOrNull(_schedule),
        active: _active,
      );
    }
    ref.invalidate(medicationListProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).medicationSaved)),
    );
    _leave();
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context)) return;
    await ref.read(medicationRepositoryProvider).delete(widget.medicationId!);
    ref.invalidate(medicationListProvider);
    if (mounted) _leave();
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/medications');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? l10n.newMedication : l10n.editMedication),
        actions: [
          if (!widget.isNew)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.deleteAction,
            ),
          IconButton(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            tooltip: l10n.saveButton,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(kGutter),
        children: [
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.medicationName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dose,
            decoration: InputDecoration(labelText: l10n.medicationDose),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _schedule,
            decoration: InputDecoration(labelText: l10n.medicationSchedule),
          ),
          if (!widget.isNew) ...[
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.medicationActive),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
          ],
        ],
      ),
    );
  }
}
