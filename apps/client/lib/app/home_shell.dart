import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

typedef _Dest = ({IconData icon, IconData selected, String label});

/// The persistent navigation frame around the three primary screens
/// (Timeline, Sessions, Tasks). A bottom bar on narrow windows, a rail on
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
      (
        icon: Icons.timeline_outlined,
        selected: Icons.timeline,
        label: l10n.navTimeline,
      ),
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
            Expanded(child: shell),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
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
