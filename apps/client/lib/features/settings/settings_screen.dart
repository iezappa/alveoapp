import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/lock_controller.dart';
import '../../app/platform.dart';
import '../../app/locale_controller.dart';
import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../app/ui.dart';
import '../../app/user_profile_controller.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../legal/legal_document_screen.dart';
import '../obsidian/obsidian_actions.dart';
import '../safety/crisis_resources.dart';
import '../security/pin_dialogs.dart';
import '../shared/name_dialog.dart';
import '../shared/support_actions.dart';
import '../shared/tutorial_dialog.dart';
import '../transfer/backup_actions.dart';
import '../transfer/erase_all_data.dart';

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
    final vault = ref.watch(obsidianVaultProvider);
    final name = ref.watch(userProfileControllerProvider).asData?.value;
    final isWeb = ref.watch(isWebProvider);

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
              Gap.vSection,
              SectionLabel(l10n.profileSection),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.namePromptLabel),
                subtitle: (name != null && name.isNotEmpty) ? Text(name) : null,
                onTap: () => promptForName(context, ref, initial: name),
              ),
              Gap.vSection,
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
              Gap.vSection,
              SectionLabel(l10n.securitySection),
              // On the web the PIN is a deterrent, not protection: say so
              // where it is set, not in a document nobody opens.
              if (isWeb) ...[
                Text(
                  l10n.pinWebCaveat,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 4),
              ],
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
              Gap.vSection,
              // Obsidian sync needs local filesystem access — desktop only.
              if (!isWeb) ...[
                SectionLabel(l10n.obsidianSection),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.folder_open_outlined),
                  title: Text(l10n.obsidianVaultFolder),
                  subtitle: Text(
                    vault.asData?.value ?? l10n.obsidianNotSet,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => pickObsidianVault(context, ref),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.arrow_upward),
                  enabled: vault.asData?.value != null,
                  title: Text(l10n.obsidianExport),
                  onTap: () => runObsidianExport(context, ref),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.arrow_downward),
                  enabled: vault.asData?.value != null,
                  title: Text(l10n.obsidianImport),
                  onTap: () => runObsidianImport(context, ref),
                ),
                Gap.vSection,
              ],
              SectionLabel(l10n.dataSectionTitle),
              // The backup notice, always on screen and above the export:
              // someone should learn that no server has a copy before they
              // need one, not after.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cloud_off_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.backupNoticeSettings,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
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
              const EraseAllDataTile(),
              Gap.vSection,
              SectionLabel(l10n.supportSection),
              const SupportProjectsCard(),
              Gap.vSection,
              SectionLabel(l10n.aboutSection),
              Text(
                l10n.settingsDisclaimerBody,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              const CrisisResourcesCard(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.privacyPolicy),
                onTap: () => _openLegal(context, LegalDocument.privacy),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.gavel_outlined),
                title: Text(l10n.termsOfUse),
                onTap: () => _openLegal(context, LegalDocument.terms),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.mail_outline),
                title: Text(l10n.developerContact),
                subtitle: const Text('$developerName\n$contactUrl'),
                isThreeLine: true,
                onTap: () => launchExternalUrl(Uri.parse(contactUrl)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: Text(l10n.openSourceLicenses),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appTitle,
                  applicationLegalese: developerName,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.school_outlined),
                title: Text(l10n.settingsTutorial),
                subtitle: Text(l10n.settingsTutorialSubtitle),
                onTap: () => showTutorial(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLegal(BuildContext context, LegalDocument document) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LegalDocumentScreen(document: document),
      ),
    );
  }

  Future<void> _setPin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pin = await promptNewPin(
      context,
      l10n.pinSet,
      note: ref.read(isWebProvider) ? l10n.pinWebCaveat : null,
    );
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

    final next = await promptNewPin(
      context,
      l10n.pinChange,
      note: ref.read(isWebProvider) ? l10n.pinWebCaveat : null,
    );
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
        child: SizedBox.square(
          dimension: 48,
          child: Center(
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
        ),
      ),
    );
  }
}
