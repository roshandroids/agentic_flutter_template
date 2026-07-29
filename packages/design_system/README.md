# design_system

Shared Material 3 theme, tokens, responsive layout, and common widgets -
one definition instead of every app/feature reinventing spacing, color, or
loading/error/empty states.

## What's here

- `AppTheme.light()` / `AppTheme.dark()` - the app's Material 3 themes.
- `AppSpacing`, `AppRadius`, `AppSemanticColors` - `ThemeExtension` token
  scales, read via `Theme.of(context).appSpacing` etc.
- `deviceTypeOf(context)` / `ResponsiveLayout` - breakpoint-based adaptive layout.
- `AppButton`, `LoadingView`, `ErrorView`, `EmptyView`, `AppScaffold` - the
  shared building blocks every feature's presentation layer should reach
  for before writing a new one.

## Why `ErrorView` takes a `core.Failure`

So error rendering is generic across every feature's repository errors
without each feature writing its own error widget - see
[ADR-0004](../../docs/adr/ADR-0004-result-failure-error-handling.md).

## Preview

`showcase/` renders every widget/token in this package as a gallery - run
it with `cd showcase && flutter run -d chrome`.
