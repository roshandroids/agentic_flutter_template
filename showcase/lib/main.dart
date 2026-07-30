import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'shell/showcase_shell.dart';

void main() => runApp(const ShowcaseApp());

/// The Playground - living documentation, integration test, and package
/// showcase for this template, organized into sections behind
/// [ShowcaseShell]'s nav chrome. See showcase/README.md.
class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Playground',
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ThemeMode.system,
    home: const ShowcaseShell(),
  );
}
