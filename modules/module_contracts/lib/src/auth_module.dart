import 'package:core/core.dart';

/// A signed-in user, as every `AuthModule` implementation exposes it -
/// deliberately minimal; a module-specific user type stays inside that
/// module, mapped to this at the boundary.
class ModuleUser {
  const ModuleUser({required this.id, this.email, this.displayName});

  final String id;
  final String? email;
  final String? displayName;
}

/// Implemented by whichever backend/auth module is enabled (`firebase`,
/// `supabase`, a custom `auth` module against this app's own API, ...).
/// `apps/app/lib/composition_root.dart` binds exactly one implementation
/// to this contract; feature code depends only on this interface.
abstract interface class AuthModule {
  Stream<ModuleUser?> get authStateChanges;

  Future<Result<ModuleUser, Failure>> signInWithEmail(
    String email,
    String password,
  );

  Future<Result<void, Failure>> signOut();
}
