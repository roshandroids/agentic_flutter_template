import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Adaptive navigation chrome around every top-level branch - bottom nav
/// on mobile, nav rail on tablet/desktop. Wraps a
/// `StatefulShellRoute.indexedStack` so each branch keeps its own
/// navigation stack. See docs/architecture/ARCHITECTURE.md "Navigation".
///
/// Only one destination exists today (Dashboard), so no nav chrome is
/// shown - Material's [NavigationBar] requires at least two destinations,
/// and a single destination has nothing to navigate between anyway. Adding
/// a second feature means adding one `StatefulShellBranch` in
/// app_router.dart and one entry to [_destinations] here; chrome appears
/// automatically once there are 2+.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _ShellDestination(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_destinations.length < 2) {
      return Scaffold(body: navigationShell);
    }

    final deviceType = deviceTypeOf(context);

    if (deviceType == DeviceType.mobile) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
