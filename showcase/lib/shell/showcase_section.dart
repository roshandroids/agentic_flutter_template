import 'package:flutter/widgets.dart';

/// One destination in the Playground's navigation shell - see
/// showcase_sections.dart for the registry and showcase_shell.dart for how
/// this renders as nav chrome.
class ShowcaseSection {
  const ShowcaseSection({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });

  /// Stable identifier for this section - not shown in the UI, but useful
  /// for locating a destination by finder in tests without depending on
  /// display-order or the label text.
  final String id;

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final WidgetBuilder builder;
}
