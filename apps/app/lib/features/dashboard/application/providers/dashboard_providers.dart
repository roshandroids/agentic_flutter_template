import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../composition_root.dart';
import '../../domain/entities/dashboard_summary.dart';

/// The dashboard feature's async state - `presentation/` reads this via
/// `AsyncValue.when`, never calls the repository directly. See
/// docs/architecture/ARCHITECTURE.md "State management - Riverpod".
final dashboardSummaryProvider =
    AsyncNotifierProvider<DashboardSummaryNotifier, DashboardSummary>(
      DashboardSummaryNotifier.new,
    );

class DashboardSummaryNotifier extends AsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() => _fetch();

  /// The mutation pattern every feature should follow: set loading, wrap
  /// the body in `AsyncValue.guard` so a thrown [Failure] becomes
  /// `AsyncValue.error` with consistent semantics, no per-call try/catch.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<DashboardSummary> _fetch() async {
    final repository = ref.watch(dashboardRepositoryProvider);
    final result = await repository.fetchSummary();
    // Throwing the Failure itself (not wrapping it) means presentation
    // code can pattern-match `error is Failure` and hand it straight to
    // design_system's ErrorView - see docs/adr/ADR-0004.
    return result.fold(
      onOk: (value) => value,
      onErr: (failure) => throw failure,
    );
  }
}
