import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../domain/safety/safety_plan.dart';
import '../../l10n/app_localizations.dart';
import 'crisis_resources.dart';
import 'safety_plan_providers.dart';
import '../shared/save_failure.dart';

class SafetyPlanScreen extends ConsumerStatefulWidget {
  const SafetyPlanScreen({super.key});

  @override
  ConsumerState<SafetyPlanScreen> createState() => _SafetyPlanScreenState();
}

class _ContactDraft {
  _ContactDraft(SafetyContact c)
    : name = TextEditingController(text: c.name),
      phone = TextEditingController(text: c.phone),
      kind = c.kind;

  final TextEditingController name;
  final TextEditingController phone;
  SafetyContactKind kind;

  void dispose() {
    name.dispose();
    phone.dispose();
  }

  SafetyContact toContact() => SafetyContact(
    name: name.text.trim(),
    phone: phone.text.trim(),
    kind: kind,
  );

  bool get isBlank => name.text.trim().isEmpty && phone.text.trim().isEmpty;
}

class _SafetyPlanScreenState extends ConsumerState<SafetyPlanScreen> {
  final _warningSigns = TextEditingController();
  final _coping = TextEditingController();
  final _distractions = TextEditingController();
  final _environment = TextEditingController();
  final _contacts = <_ContactDraft>[];

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final plan = await ref.read(safetyPlanRepositoryProvider).load();
      if (!mounted) return;
      setState(() {
        _warningSigns.text = plan.warningSigns;
        _coping.text = plan.copingStrategies;
        _distractions.text = plan.distractions;
        _environment.text = plan.environmentSafety;
        _contacts.addAll(plan.contacts.map(_ContactDraft.new));
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _warningSigns.dispose();
    _coping.dispose();
    _distractions.dispose();
    _environment.dispose();
    for (final c in _contacts) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final plan = SafetyPlan(
      warningSigns: _warningSigns.text.trim(),
      copingStrategies: _coping.text.trim(),
      distractions: _distractions.text.trim(),
      environmentSafety: _environment.text.trim(),
      contacts: [
        for (final c in _contacts)
          if (!c.isBlank) c.toContact(),
      ],
    );
    final saved = await saveOrReport(context, () async {
      await ref.read(safetyPlanRepositoryProvider).save(plan);
    });
    if (!saved) {
      if (mounted) setState(() => _saving = false);
      return;
    }

    ref.invalidate(safetyPlanProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).safetyPlanSaved)),
    );
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
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
        title: Text(l10n.safetyPlanTitle),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            tooltip: l10n.saveButton,
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.all(kGutter),
            children: [
              // Who to call comes before the plan: whoever opens this screen
              // in a bad moment should not have to scroll to find it.
              const CrisisResourcesCard(),
              const SizedBox(height: 20),
              _section(l10n.safetyWarningSigns, _warningSigns),
              _section(l10n.safetyCoping, _coping),
              _section(l10n.safetyDistractions, _distractions),
              _section(l10n.safetyEnvironment, _environment),
              const SizedBox(height: 8),
              SectionLabel(l10n.safetyContacts),
              const SizedBox(height: 8),
              for (var i = 0; i < _contacts.length; i++) _contactRow(l10n, i),
              const SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: () => setState(
                    () => _contacts.add(
                      _ContactDraft(const SafetyContact(name: '', phone: '')),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.safetyAddContact),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          minLines: 2,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    ),
  );

  Widget _contactRow(AppLocalizations l10n, int index) {
    final draft = _contacts[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: draft.name,
                  decoration: InputDecoration(hintText: l10n.safetyContactName),
                ),
              ),
              IconButton(
                onPressed: () => setState(() {
                  _contacts.removeAt(index).dispose();
                }),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: draft.phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: l10n.safetyContactPhone,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<SafetyContactKind>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: SafetyContactKind.support,
                    label: Text(l10n.safetyContactSupport),
                  ),
                  ButtonSegment(
                    value: SafetyContactKind.professional,
                    label: Text(l10n.safetyContactProfessional),
                  ),
                ],
                selected: {draft.kind},
                onSelectionChanged: (s) => setState(() => draft.kind = s.first),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
