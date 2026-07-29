import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/feature_name.dart';

// TODO: bind featureNameRepositoryProvider at
// apps/app/lib/composition_root.dart, following dashboardRepositoryProvider's
// pattern, then import it here instead of leaving this unresolved.

/// `presentation/` reads this via `AsyncValue.when`, never calls the
/// repository directly. See docs/architecture/ARCHITECTURE.md
/// "State management - Riverpod".
final featureNameProvider =
    AsyncNotifierProvider<FeatureNameNotifier, FeatureName>(
      FeatureNameNotifier.new,
    );

class FeatureNameNotifier extends AsyncNotifier<FeatureName> {
  @override
  Future<FeatureName> build() => _fetch();

  /// The mutation pattern every feature should follow: set loading, wrap
  /// the body in `AsyncValue.guard` so a thrown `Failure` becomes
  /// `AsyncValue.error` with consistent semantics.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<FeatureName> _fetch() async {
    // TODO: replace with `ref.watch(featureNameRepositoryProvider).fetch()`
    // and `result.fold(onOk: (v) => v, onErr: (f) => throw f)` once the
    // repository provider exists - see dashboard's providers for the
    // exact pattern.
    throw UnimplementedError(
      'Wire featureNameRepositoryProvider in composition_root.dart first.',
    );
  }
}
