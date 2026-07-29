import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/__feature__.dart';

// TODO: bind __featureCamel__RepositoryProvider at
// apps/app/lib/composition_root.dart, following dashboardRepositoryProvider's
// pattern, then import it here instead of leaving this unresolved.

/// `presentation/` reads this via `AsyncValue.when`, never calls the
/// repository directly. See docs/architecture/ARCHITECTURE.md
/// "State management - Riverpod".
final __featureCamel__Provider =
    AsyncNotifierProvider<__Feature__Notifier, __Feature__>(
      __Feature__Notifier.new,
    );

class __Feature__Notifier extends AsyncNotifier<__Feature__> {
  @override
  Future<__Feature__> build() => _fetch();

  /// The mutation pattern every feature should follow: set loading, wrap
  /// the body in `AsyncValue.guard` so a thrown `Failure` becomes
  /// `AsyncValue.error` with consistent semantics.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<__Feature__> _fetch() async {
    // TODO: replace with `ref.watch(__featureCamel__RepositoryProvider).fetch()`
    // and `result.fold(onOk: (v) => v, onErr: (f) => throw f)` once the
    // repository provider exists - see dashboard's providers for the
    // exact pattern.
    throw UnimplementedError(
      'Wire __featureCamel__RepositoryProvider in composition_root.dart first.',
    );
  }
}
