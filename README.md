# Agentic Flutter Template

A production-grade, AI-first Flutter monorepo template - feature-first
Clean Architecture, Riverpod, go_router, Melos/pub-workspaces, modular
CI/CD, and a documentation system built to be lived in for years, not
skimmed once at clone time.

This is not a demo. The **repository itself is the deliverable** - a
foundation you clone once and evolve for every future Flutter app.

## Quick start

```bash
git clone <this-repo> my_app && cd my_app
./scripts/bootstrap.sh   # installs Melos, resolves the whole workspace
./scripts/doctor.sh      # verifies your toolchain is ready
./scripts/verify.sh      # format check + analyze + boundaries + tests + coverage
```

Run the app: `cd apps/app && flutter run`
Run the design-system gallery: `cd showcase && flutter run -d chrome`

## What's here

| Path | What it is |
|---|---|
| [`apps/app`](apps/app) | The product application - one demonstration feature (`dashboard`), fully layered. |
| [`packages/`](packages) | Reusable, app-agnostic code: `core`, `network`, `local_storage`, `design_system`. |
| [`modules/`](modules) | Pluggable backend/service integrations (auth, analytics, payments, ...) behind contracts. |
| [`showcase/`](showcase) | A gallery of every design-system token and widget. |
| [`docs/`](docs) | The documentation system - see [`docs/README.md`](docs/README.md) for the map. |
| [`.ai/`](.ai) | The single canonical source of AI instructions - see [`.ai/AGENTS.md`](.ai/AGENTS.md). |
| [`scripts/`](scripts) | All repo automation - see [`docs/reference/SCRIPTS.md`](docs/reference/SCRIPTS.md). |
| [`.github/`](.github) | Modular CI/CD workflows, issue/PR templates, CODEOWNERS. |
| [`template.config.yaml`](template.config.yaml) | Single source of truth driving the tooling - see [`docs/reference/PROJECT_CONFIGURATION.md`](docs/reference/PROJECT_CONFIGURATION.md). |

## Why it's built this way

Every non-obvious decision has a corresponding ADR under
[`docs/adr/`](docs/adr) - why Riverpod, why go_router, why a monorepo, why
`Result<T, Failure>` instead of exceptions, why AI instructions live in one
place. Start with [`docs/architecture/README.md`](docs/architecture/README.md)
for the current shape, and [`docs/adr/README.md`](docs/adr/README.md) for
the reasoning behind it.

## Contributing

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) before your first PR - this repo
is documentation-first: architectural changes get an ADR, and the docs
change in the same PR as the code, not after.

## AI-assisted development

Claude Code, Cursor, GitHub Copilot, ChatGPT, and Gemini are all supported
from **one canonical instruction file**: [`.ai/AGENTS.md`](.ai/AGENTS.md).
Every tool-specific file (`CLAUDE.md`, `.cursor/rules/`,
`.github/copilot-instructions.md`) is a thin pointer back to it - see
[ADR-0005](docs/adr/ADR-0005-ai-single-source-of-truth.md).

## License

[MIT](LICENSE)
