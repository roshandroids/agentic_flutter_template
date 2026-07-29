import 'package:core/core.dart';

import '../entities/__feature__.dart';

/// The contract `application/` depends on; `infrastructure/` implements
/// it. `application/` code never imports the `*RepositoryImpl` directly -
/// only this interface, bound at `apps/app/lib/composition_root.dart`.
abstract interface class __Feature__Repository {
  Future<Result<__Feature__, Failure>> fetch();
}
