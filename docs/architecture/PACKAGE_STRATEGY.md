# Package strategy

## When code is a `packages/*` package vs. app code

Default to `apps/app/lib/features/<feature>/`. Promote to `packages/*` only when one of these is true:

1. **A second consumer exists or is imminent** - another app in `apps/`, or
   `showcase/` needs it to demonstrate the design system.
2. **It's infrastructure that's genuinely app-agnostic** - `packages/core`,
   `packages/network`, `packages/local_storage`, `packages/design_system`
   qualify by definition; a feature's business logic almost never does.
3. **It's a deliberate open-source extraction candidate** - documented as
   such in an ADR before extraction, not decided retroactively.

**Why not extract everything into packages from day one:** a package
boundary has real cost - a separate `pubspec.yaml`, its own versioning,
its own test suite, an explicit public API to maintain. Paying that cost
for code with exactly one caller is pure overhead; it's easier to promote a
well-isolated `features/dashboard/` folder into `packages/dashboard/` later
(the four-layer structure already matches what a package needs) than to
un-couple a premature package back into app code.

## Current packages

| Package | Layer | Why it's a package, not app code |
|---|---|---|
| `packages/core` | domain | Consumed by every other package and the app; must stay Flutter-free to be unit-testable and reusable outside Flutter. |
| `packages/network` | infrastructure | App-agnostic HTTP concern; would be identical in a second app. |
| `packages/local_storage` | infrastructure | Same - app-agnostic persistence concern. |
| `packages/design_system` | presentation | The whole point of a design system is one definition shared by every app and by `showcase/`. |

## Extracting a feature into a package later

1. Confirm a second real consumer exists (not hypothetical).
2. Write an ADR naming the extraction and what public API the new package commits to.
3. `./scripts/new_package.sh <name>`, move the feature's four layers in,
   replace internal imports with the new package's public exports.
4. The app depends on the new package like any other - no special case.

## Versioning

Independent per-package versioning via `melos version` (Conventional
Commits scoped to the package name, e.g. `feat(design_system): ...`) - see
[`../release/VERSIONING.md`](../release/VERSIONING.md). Packages evolve on
their own schedule; a `design_system` patch release doesn't force a `core`
version bump.
