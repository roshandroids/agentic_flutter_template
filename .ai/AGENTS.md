# AGENTS.md - canonical AI instructions

This file is the **single source of truth** for every AI surface working in
this repository - Claude Code, Cursor, GitHub Copilot, ChatGPT, Gemini, or
any future tool. Every tool-specific file (`/CLAUDE.md`, `.cursor/rules/`,
`.github/copilot-instructions.md`) is a thin pointer back to this one. Do not
add project instructions anywhere else - if you find yourself writing
"remember to..." in a tool-specific file, move it here instead.

**Why one file, not five:** five parallel instruction sets drift. Six months
in, `.cursorrules` says one thing and `.claude/CLAUDE.md` says another,
and nobody notices until an agent does the wrong thing confidently. One file
that every adapter points to cannot drift from itself.

## What this repository is

A Flutter monorepo template: feature-first Clean Architecture, Riverpod for
state, go_router for navigation, Melos for the package workspace. Read
[docs/architecture/README.md](../docs/architecture/README.md) before touching
architecture; read [template.config.yaml](../template.config.yaml) before
assuming what's enabled.

## Rules an agent must follow in this repo

1. **Layer boundaries are enforced, not suggested.** `packages/core` has zero
   Flutter imports and zero imports of other local packages. Read
   [docs/architecture/DEPENDENCY_RULES.md](../docs/architecture/DEPENDENCY_RULES.md)
   before adding an import across a package boundary. If unsure, run
   `./scripts/check_dependency_boundaries.sh` - it is the same check CI runs.
2. **No placeholder documentation or code.** Don't scaffold a doc, test, or
   function you don't intend to fill in this change. An empty "TODO: fill
   this in later" is worse than not creating the file.
3. **Architectural changes need an ADR.** New package, new state pattern, new
   navigation shape, new persisted-data format → `./scripts/new_adr.sh
   "title"` before writing the implementation, not after.
4. **Follow the dev lifecycle in [workflow/WORKFLOW.md](workflow/WORKFLOW.md).**
   This repo's real development pipeline is intake → technical analysis →
   development → finish (self-review + commit + PR) → review-feedback →
   review-fixes → merge-ready. The agent specs in [agents/](agents/) mirror
   these stages 1:1 - don't invent a different pipeline shape.
5. **Tests live at the layer that changed.** Domain logic → unit test in the
   same package. Widget → widget test. Cross-feature flow → integration test.
   See [docs/testing/README.md](../docs/testing/README.md).
6. **Never commit secrets.** `.env`, keystores, and service-account JSON are
   gitignored on purpose - see [docs/operations/SECRETS.md](../docs/operations/SECRETS.md).

## Directory guide

| Path | Purpose |
|---|---|
| [`roles/`](roles/) | Persona definitions (architect, implementer, reviewer, tester, doc-writer) - what each *kind* of work should optimize for. |
| [`agents/`](agents/) | Concrete task pipelines: one file per dev-lifecycle stage, matching `workflow/WORKFLOW.md`. |
| [`prompts/`](prompts/) | Small reusable prompt fragments (commit message shape, ADR-writing prompt) - composed into agents, not duplicated across them. |
| [`memory/`](memory/) | Durable repo-level knowledge an agent should load and update: decisions, glossary, known gotchas. Distinct from any tool's private session memory. |
| [`context/`](context/) | "When touching X, read Y first" maps - keeps agents from re-discovering the same files every session. |
| [`handoff/`](handoff/) | End-of-session handoff protocol so the next session (human or agent) starts oriented, not from zero. |
| [`reports/`](reports/) | Structured output agents write during the pipeline (self-review, merge-readiness) - dated, append-only. |
| [`templates/`](templates/) | Fill-in-the-blank templates (ADR, PR description, bug report) consumed by `scripts/new_*.sh`. |
| [`workflow/`](workflow/) | The dev lifecycle state machine itself. |

## Supported surfaces and their adapter files

| Surface | Adapter file | What it does |
|---|---|---|
| Claude Code | `/CLAUDE.md` | Points here; project-level skills under `.claude/skills/` point to `agents/`. |
| Cursor | `.cursor/rules/000-canonical.mdc` | Points here. |
| GitHub Copilot | `.github/copilot-instructions.md` | Points here. |
| ChatGPT / Gemini (no fixed convention) | `/AGENTS.md` (repo root) | Root-level file several tools now auto-discover; also the one to paste manually. |

If you are an agent reading this and your tool has its own convention this
table doesn't cover: still treat this file as authoritative, and don't create
a new adapter file without adding a row here.
