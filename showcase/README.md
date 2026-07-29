# showcase

A gallery of every token and shared widget in `packages/design_system` -
buttons, loading/error/empty states, the spacing and radius scales, and
the current responsive breakpoint. Exists so a design-system change is
visible immediately, without running the full `apps/app` or hunting
through a feature to find where a widget happens to be used.

## Running

```bash
flutter run -d chrome
```

## Keeping this in sync

Adding a new shared widget or token to `packages/design_system` should
come with a new section here in the same PR - see
[`../CONTRIBUTING.md`](../CONTRIBUTING.md)'s documentation-first rule,
applied to the design system's own visual documentation.
