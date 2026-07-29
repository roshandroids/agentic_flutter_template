import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import 'app_shell.dart';

/// Centralized, typed routes - feature code never calls `Navigator.push`
/// directly. See docs/architecture/ARCHITECTURE.md "Navigation" and
/// docs/adr/ADR-0002.
///
/// No `redirect` (auth guard) is wired yet - there is no auth module
/// enabled (`template.config.yaml`'s `modules.enabled` is empty). Once one
/// is added (`./scripts/new_module.sh auth`), add a `redirect:` callback
/// here reading that module's auth-state provider; this is the extension
/// point ADR-0002 describes, not something already active.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
