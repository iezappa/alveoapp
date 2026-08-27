import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/lock_controller.dart';
import '../../app/locale_controller.dart';
import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../app/ui.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../security/pin_dialogs.dart';
import '../transfer/backup_actions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chosen = ref.watch(localeControllerProvider);
    final active =
        chosen?.languageCode ?? Localizations.localeOf(context).languageCode;
    final hasPin = ref.watch(hasPinProvider);
    final theme = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: const EdgeInsets.all(kGutter),
            children: [
              SectionLabel(l10n.appearanceSection),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {theme.mode},
                showSelectedIcon: false,
                onSelectionChanged: (s) =>
                    ref.read(themeControllerProvider.notifier).setMode(s.first),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.accentColor,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final accent in AppAccent.values)
                    _AccentSwatch(
                      key: ValueKey('accent-${accent.name}'),
                      accent: accent,
                      selected: accent == theme.accent,
                      onTap: () => ref
                          .read(themeControllerProvider.notifier)
                          .setAccent(accent),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              SectionLabel(l10n.settingsLanguage),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'es', label: Text(l10n.languageSpanish)),
                  ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
                ],
                selected: {active == 'es' ? 'es' : 'en'},
                onSelectionChanged: (selection) {
                  ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(Locale(selection.first));
                },
              ),
              const SizedBox(height: 28),
              SectionLabel(l10n.pinSectionTitle),
              hasPin.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (enabled) => enabled
                    ? Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.password_outlined),
                            title: Text(l10n.pinChange),
                            onTap: () => _changePin(context, ref),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.lock_open_outlined),
                            title: Text(l10n.pinRemove),
                            onTap: () => _removePin(context, ref),
                          ),
                        ],
                      )
                    : ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.lock_outline),
                        title: Text(l10n.pinSet),
                        onTap: () => _setPin(context, ref),
                      ),
              ),
              const SizedBox(height: 28),
              SectionLabel(l10n.dataSectionTitle),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.upload_file_outlined),
                title: Text(l10n.exportBackup),
                onTap: () => runExportBackup(context, ref),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.download_outlined),
                title: Text(l10n.importBackup),
                onTap: () => runImportBackup(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setPin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pin = await promptNewPin(context, l10n.pinSet);
    if (pin == null) return;

    await ref.read(pinServiceProvider).setPin(pin);
    ref.invalidate(hasPinProvider);
    messenger.showSnackBar(SnackBar(content: Text(l10n.pinUpdated)));
  }

  Future<void> _changePin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pinService = ref.read(pinServiceProvider);

    final current = await promptExistingPin(context, l10n.pinChange);
    if (current == null) return;
    if (!await pinService.verify(current)) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.pinWrong)));
      return;
    }
    if (!context.mounted) return;

    final next = await promptNewPin(context, l10n.pinChange);
    if (next == null) return;

    await pinService.setPin(next);
    ref.invalidate(hasPinProvider);
    messenger.showSnackBar(SnackBar(content: Text(l10n.pinUpdated)));
  }

  Future<void> _removePin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pinService = ref.read(pinServiceProvider);

    final current = await promptExistingPin(context, l10n.pinRemove);
    if (current == null) return;
    if (!await pinService.verify(current)) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.pinWrong)));
      return;
    }

    await pinService.clearPin();
    ref.invalidate(hasPinProvider);
    messenger.showSnackBar(SnackBar(content: Text(l10n.pinRemoved)));
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    super.key,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final AppAccent accent;
  final bool selected;
  final VoidCallback onTap;

  String _name(AppLocalizations l10n) => switch (accent) {
    AppAccent.green => l10n.accentGreen,
    AppAccent.blue => l10n.accentBlue,
    AppAccent.pink => l10n.accentPink,
    AppAccent.violet => l10n.accentViolet,
    AppAccent.orange => l10n.accentOrange,
    AppAccent.red => l10n.accentRed,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: _name(AppLocalizations.of(context)),
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.seed,
            border: Border.all(
              color: selected ? scheme.onSurface : Colors.transparent,
              width: 2,
            ),
          ),
          child: selected
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
