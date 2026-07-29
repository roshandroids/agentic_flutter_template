import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';

/// A [Scaffold] with the app's standard body padding applied - so
/// per-screen padding isn't reinvented (and doesn't drift) per feature.
/// Adaptive navigation chrome (nav rail vs. bottom bar) is layered around
/// this by `apps/app/lib/routing/app_shell.dart`, not by this widget - a
/// screen shouldn't need to know whether it's inside a shell.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.applyBodyPadding = true,
  });

  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  /// Screens that manage their own edge-to-edge layout (e.g. a full-bleed
  /// list) can opt out of the standard padding.
  final bool applyBodyPadding;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).appSpacing;
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(title: Text(title!), actions: actions),
      floatingActionButton: floatingActionButton,
      body: applyBodyPadding
          ? Padding(padding: EdgeInsets.all(spacing.md), child: body)
          : body,
    );
  }
}
