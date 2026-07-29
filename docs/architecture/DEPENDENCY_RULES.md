# Dependency rules

Every rule here is enforced by `./scripts/check_dependency_boundaries.sh`
(the same script CI runs in `.github/workflows/dependency_validate.yml`) -
not just documented convention. A rule that only lives in a doc gets
violated the first time someone is in a hurry; a rule a script fails the
build on doesn't.

## The rules

| Package/layer | May import | Must never import |
|---|---|---|
| `packages/core` | Dart SDK only | `package:flutter`, any other local package |
| `packages/network` | `packages/core`, `dio` | `package:flutter`, `packages/design_system` |
| `packages/local_storage` | `packages/core`, `shared_preferences`, `flutter_secure_storage` | `packages/network`, `packages/design_system` |
| `packages/design_system` | `packages/core` (types only, e.g. `Failure` for an `ErrorView`) | `packages/network`, `packages/local_storage` |
| `modules/module_contracts` | Dart SDK only | `package:flutter`, any other local package - a contract must stay implementable by any SDK a concrete module chooses to wrap |
| `apps/app/lib/features/*/domain` | Dart SDK, that feature's own domain only | `package:flutter`, `infrastructure/`, `presentation/` |
| `apps/app/lib/features/*/application` | that feature's `domain/`, `packages/core` | `infrastructure/` concrete classes (only via DI-provided interfaces), `presentation/` |
| `apps/app/lib/features/*/infrastructure` | that feature's `domain/`, `packages/network`, `packages/local_storage` | `presentation/` |
| `apps/app/lib/features/*/presentation` | that feature's `application/`, `packages/design_system` | infrastructure concrete classes directly, another feature's `internal` files |
| `apps/app/lib/composition_root.dart` | everything | - (this is the one intentional exception; it's where concrete implementations meet abstract interfaces) |

## Why enforced, not just documented

`packages/core` staying Flutter-free is what makes it possible to unit-test
domain logic in milliseconds without a widget test harness, and to reuse it
outside Flutter entirely (a CLI tool, a server) if that's ever needed. One
accidental `import 'package:flutter/foundation.dart';` for a `@required`
annotation quietly forecloses that - which is exactly the kind of mistake
that's easy to make at 5pm on a Friday and easy for a CI gate to catch in
30 seconds.

## How the check works

`scripts/check_dependency_boundaries.sh` reads `template.config.yaml`'s
`packages:` list for the package → layer mapping, then greps each package's
`lib/` for forbidden `import` statements. Adding a new pure-Dart package
means adding one entry to `template.config.yaml` - the script doesn't need
editing.

That `packages:` list is scoped to code that commits to a fixed
architectural layer - it is not the same set as the root `pubspec.yaml`'s
`workspace:` list. `apps/app` and `showcase` are consumers of the layered
packages, not layered packages themselves; `tools/repo_tools` is a dev
tool; concrete `modules/*` (e.g. `modules/analytics`) deliberately opt out
because a module is allowed to depend on whatever SDK it wraps, including
Flutter plugins (see `modules/README.md`). Only `modules/module_contracts`
is enforced, because contracts must stay Flutter-free the same way
`packages/core` does. `scripts/doctor.sh` checks that every path in
`packages:` is a registered workspace member (so boundary checks never
silently no-op on a package that doesn't actually resolve) - it does not
require every workspace member to appear in `packages:`.

## Cross-feature imports

A feature may depend on another feature's `domain/` (its public
vocabulary), never its `application/`, `infrastructure/`, or `presentation/`
- those are that feature's implementation detail. If two features need to
share application-level logic, that's a signal that logic belongs in
`packages/core` or a new shared package, not in either feature.
