import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'showcase_sections.dart';

/// Adaptive navigation chrome around every Playground section - bottom
/// nav on mobile, nav rail on tablet/desktop, mirroring
/// apps/app/lib/routing/app_shell.dart's pattern (see ADR-0002). Each
/// section owns its own `AppScaffold`/title, same as apps/app's feature
/// screens - this shell only supplies the nav chrome. [IndexedStack]
/// keeps every section mounted, so switching sections never rebuilds one
/// from scratch (e.g. Modules' triggered-events list survives a tab
/// switch), the same guarantee go_router's `StatefulShellRoute.indexedStack`
/// gives apps/app.
///
/// Adding a section is one entry in showcase_sections.dart - nothing here
/// needs to change.
class ShowcaseShell extends StatefulWidget {
  const ShowcaseShell({super.key});

  @override
  State<ShowcaseShell> createState() => _ShowcaseShellState();
}

class _ShowcaseShellState extends State<ShowcaseShell> {
  int _selectedIndex = 0;

  void _select(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(
      index: _selectedIndex,
      children: [
        for (final section in showcaseSections)
          Builder(builder: section.builder),
      ],
    );

    if (deviceTypeOf(context) == DeviceType.mobile) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _select,
          destinations: [
            for (final section in showcaseSections)
              NavigationDestination(
                icon: Icon(section.icon),
                selectedIcon: Icon(section.selectedIcon),
                label: section.label,
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _select,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final section in showcaseSections)
                NavigationRailDestination(
                  icon: Icon(section.icon),
                  selectedIcon: Icon(section.selectedIcon),
                  label: Text(section.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
