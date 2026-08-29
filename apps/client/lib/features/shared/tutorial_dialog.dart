import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/locale_controller.dart';
import '../../l10n/app_localizations.dart';
import 'support_actions.dart';

/// Opens the usage walkthrough as a pop-up. Shown once on first launch and
/// re-openable from Settings. The caller decides whether to mark it as seen.
Future<void> showTutorial(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _TutorialDialog(),
  );
}

class _TutorialStep {
  const _TutorialStep(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

class _TutorialDialog extends ConsumerStatefulWidget {
  const _TutorialDialog();

  @override
  ConsumerState<_TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends ConsumerState<_TutorialDialog> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_TutorialStep> _steps(AppLocalizations l10n) => [
    _TutorialStep(
      Icons.spa_outlined,
      l10n.tutorialWelcomeTitle,
      l10n.tutorialWelcomeBody,
    ),
    _TutorialStep(
      Icons.favorite_outline,
      l10n.tutorialCheckInTitle,
      l10n.tutorialCheckInBody,
    ),
    _TutorialStep(
      Icons.edit_note_outlined,
      l10n.tutorialWriteTitle,
      l10n.tutorialWriteBody,
    ),
    _TutorialStep(
      Icons.self_improvement_outlined,
      l10n.tutorialToolsTitle,
      l10n.tutorialToolsBody,
    ),
    _TutorialStep(
      Icons.dashboard_customize_outlined,
      l10n.tutorialReviewTitle,
      l10n.tutorialReviewBody,
    ),
  ];

  /// The first slide carries the language switch and the support links on top
  /// of the welcome copy, so a new user meets both before anything else.
  Widget _welcomeSlide(_TutorialStep step) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final chosen = ref.watch(localeControllerProvider);
    final active =
        chosen?.languageCode ?? Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(step.icon, size: 44, color: theme.colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            step.body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.settingsLanguage,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'es', label: Text(l10n.languageSpanish)),
              ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
            ],
            selected: {active == 'es' ? 'es' : 'en'},
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              ref
                  .read(localeControllerProvider.notifier)
                  .setLocale(Locale(selection.first));
            },
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),
          const SupportProjectsCard(),
        ],
      ),
    );
  }

  Widget _plainSlide(_TutorialStep step) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(step.icon, size: 44, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              step.body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final steps = _steps(l10n);
    final isLast = _page == steps.length - 1;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SizedBox(
        width: 320,
        height: 360,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.tutorialSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: steps.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => i == 0
                    ? _welcomeSlide(steps[i])
                    : _plainSlide(steps[i]),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < steps.length; i++)
                  Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (_page > 0)
          TextButton(
            onPressed: () => _controller.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            ),
            child: Text(l10n.tutorialBack),
          ),
        FilledButton(
          onPressed: isLast
              ? () => Navigator.of(context).pop()
              : () => _controller.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
          child: Text(isLast ? l10n.tutorialDone : l10n.tutorialNext),
        ),
      ],
    );
  }
}
