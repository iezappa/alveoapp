import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/recovery/storage_warning_banner.dart';
import '../features/transfer/backup_reminder_banner.dart';
import '../features/update/update_banner.dart';
import '../l10n/app_localizations.dart';

typedef _Dest = ({IconData icon, IconData selected, String label});

/// The persistent navigation frame around the primary screens (Dashboard,
/// Journal, Sessions, Tasks, Tools). A bottom bar on narrow windows, a rail on
/// wide ones. Editors and Settings are pushed on top and sit outside it.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _railBreakpoint = 720.0;

  void _select(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = <_Dest>[
      (icon: Icons.home_outlined, selected: Icons.home, label: l10n.navHome),
      (icon: Icons.book_outlined, selected: Icons.book, label: l10n.navJournal),
      (
        icon: Icons.psychology_outlined,
        selected: Icons.psychology,
        label: l10n.navSessions,
      ),
      (
        icon: Icons.checklist_outlined,
        selected: Icons.checklist,
        label: l10n.navTasks,
      ),
      (
        icon: Icons.lightbulb_outline,
        selected: Icons.lightbulb,
        label: l10n.navTools,
      ),
    ];

    final wide = MediaQuery.sizeOf(context).width >= _railBreakpoint;

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _select,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selected),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _WithNotices(child: shell)),
          ],
        ),
      );
    }

    return Scaffold(
      body: _WithNotices(child: shell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _select,
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selected),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

/// The open tab, with any data-safety notice docked under it.
///
/// At the bottom rather than the top: the tabs bring their own app bars, and
/// a banner pushed above them would sit between the status bar and the
/// title. Down here it covers nothing and blocks nothing.
class _WithNotices extends StatelessWidget {
  const _WithNotices({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(child: child),
      const StorageWarningBanner(),
      const UpdateBanner(),
      const BackupReminderBanner(),
    ],
  );
}
