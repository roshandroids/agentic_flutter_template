# Decisions that changed agent behavior

Format: `- [ADR-XXXX](../../docs/adr/ADR-XXXX-slug.md) — one-line behavioral impact.`

- [ADR-0001](../../docs/adr/ADR-0001-riverpod-for-state-management.md) — all
  state is Riverpod providers; never introduce `Provider`/`setState`-based
  state management or a second DI mechanism.
- [ADR-0002](../../docs/adr/ADR-0002-go-router-for-navigation.md) — all
  navigation goes through typed `go_router` routes in
  `apps/app/lib/routing/`; never call `Navigator.push` directly in feature code.
- [ADR-0003](../../docs/adr/ADR-0003-melos-monorepo-package-strategy.md) —
  new reusable code is a package under `packages/`, not a `lib/shared/`
  folder inside the app.
- [ADR-0004](../../docs/adr/ADR-0004-result-failure-error-handling.md) —
  repositories and use cases return `Result<T>`, never throw for expected
  failure paths; `throw` is reserved for programmer errors.
- [ADR-0005](../../docs/adr/ADR-0005-ai-single-source-of-truth.md) — AI
  instructions live only in `.ai/`; never add project rules directly to
  `.cursor/`, `.claude/`, or `.github/copilot-instructions.md`.
