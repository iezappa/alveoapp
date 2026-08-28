import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

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

class _TutorialDialog extends StatefulWidget {
  const _TutorialDialog();

  @override
  State<_TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<_TutorialDialog> {
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
        height: 340,
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
                itemBuilder: (context, i) {
                  final step = steps[i];
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            step.icon,
                            size: 44,
                            color: theme.colorScheme.primary,
                          ),
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
                },
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
