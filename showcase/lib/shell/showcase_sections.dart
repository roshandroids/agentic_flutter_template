import 'package:flutter/material.dart';

import '../modules/modules_screen.dart';
import '../sections/components/components_screen.dart';
import '../sections/design_tokens/design_tokens_screen.dart';
import '../sections/home/home_screen.dart';
import '../sections/packages/packages_screen.dart';
import '../sections/responsive/responsive_screen.dart';
import 'showcase_section.dart';

/// Every destination in the Playground, in nav order. Adding a section is
/// one entry here - see showcase/README.md "Adding a section". Nothing in
/// showcase_shell.dart needs to change when this list grows.
final List<ShowcaseSection> showcaseSections = [
  ShowcaseSection(
    id: 'home',
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    builder: (_) => const HomeScreen(),
  ),
  ShowcaseSection(
    id: 'packages',
    label: 'Packages',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    builder: (_) => const PackagesScreen(),
  ),
  ShowcaseSection(
    id: 'components',
    label: 'Components',
    icon: Icons.widgets_outlined,
    selectedIcon: Icons.widgets,
    builder: (_) => const ComponentsScreen(),
  ),
  ShowcaseSection(
    id: 'design_tokens',
    label: 'Design tokens',
    icon: Icons.palette_outlined,
    selectedIcon: Icons.palette,
    builder: (_) => const DesignTokensScreen(),
  ),
  ShowcaseSection(
    id: 'responsive',
    label: 'Responsive',
    icon: Icons.devices_outlined,
    selectedIcon: Icons.devices,
    builder: (_) => const ResponsiveScreen(),
  ),
  ShowcaseSection(
    id: 'modules',
    label: 'Modules',
    icon: Icons.extension_outlined,
    selectedIcon: Icons.extension,
    builder: (_) => const ModulesScreen(),
  ),
];
