# showcase

The Playground - living documentation, integration test, and package
showcase for this template. Every reusable package (`packages/*`) and
module (`modules/*`) gets a section here, demonstrated with real, working
code - not a mockup. Exists so a change is visible immediately, without
running the full `apps/app` or hunting through a feature to find where
something is used.

## Running

```bash
flutter run -d chrome
```

## Structure

- `lib/shell/` - the navigation shell (`ShowcaseShell`) and the section
  registry (`showcase_sections.dart`). Bottom nav on mobile, nav rail on
  tablet/desktop - mirrors `apps/app/lib/routing/app_shell.dart`'s pattern
  (see [ADR-0002](../docs/adr/ADR-0002-go-router-for-navigation.md)), but
  without go_router: the Playground is a flat list of sections, not a
  deep-linked app, so a plain `IndexedStack` + `NavigationRail`/
  `NavigationBar` gets the same adaptive chrome with zero extra
  dependencies.
- `lib/sections/<name>/` - one section per screen. Each owns its own
  `AppScaffold`/title, same as an `apps/app` feature screen.
- `lib/modules/` - the Modules section, demonstrating the module registry
  (see [`modules/README.md`](../modules/README.md)).

## Adding a section

1. Add a screen under `lib/sections/<name>/<name>_screen.dart`.
2. Add one `ShowcaseSection` entry to `lib/shell/showcase_sections.dart`.
   Nothing in `showcase_shell.dart` needs to change.
3. Add a widget test for the screen, and cover navigating to it from
   `ShowcaseShell` in `test/shell/showcase_shell_test.dart`.

## Keeping this in sync

A package is not complete until it has a Playground section. Adding a new
shared widget, package, or module should come with a Playground update in
the same PR - see [`../CONTRIBUTING.md`](../CONTRIBUTING.md)'s
documentation-first rule, applied to this template's executable
specification.
