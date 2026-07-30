import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../shell/section_heading.dart';

/// The breakpoint the shell around this very screen switches on - see
/// packages/design_system/lib/src/responsive/breakpoints.dart and
/// shell/showcase_shell.dart.
class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) => const AppScaffold(
    title: 'Responsive',
    body: SectionHeading(
      title: 'Current breakpoint',
      child: _BreakpointShowcase(),
    ),
  );
}

class _BreakpointShowcase extends StatelessWidget {
  const _BreakpointShowcase();

  @override
  Widget build(BuildContext context) => ResponsiveLayout(
    mobile: (_) => const Text('Current: mobile (<600px)'),
    tablet: (_) => const Text('Current: tablet (600-1024px)'),
    desktop: (_) => const Text('Current: desktop (≥1024px)'),
  );
}
