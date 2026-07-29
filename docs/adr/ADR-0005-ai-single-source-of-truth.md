# ADR-0005: `.ai/` as the single AI source of truth

**Status:** Accepted
**Date:** 2026-07-28

## Context

This template must support Claude Code, Cursor, GitHub Copilot, ChatGPT,
and Gemini simultaneously, without each tool's instruction file drifting
from the others. Five parallel instruction sets (`.cursorrules`,
`.claude/CLAUDE.md`, `.github/copilot-instructions.md`, ad-hoc pasted
context for ChatGPT/Gemini) is the natural failure mode if each tool's
config is authored independently - six months in, one says "use Riverpod"
and another still says "Provider is fine," and nobody notices until an
agent acts on the stale one.

## Decision

All AI-facing instructions live under `.ai/` (`AGENTS.md` plus
`roles/`, `agents/`, `prompts/`, `memory/`, `context/`, `handoff/`,
`reports/`, `templates/`, `workflow/`). Every tool-specific file
(`/CLAUDE.md`, `/AGENTS.md` at root, `.cursor/rules/000-canonical.mdc`,
`.github/copilot-instructions.md`) is a short pointer back to
`.ai/AGENTS.md` and contains no project instructions of its own.

## Alternatives considered

- **One instruction set per tool, kept manually in sync** - rejected: "keep
  these in sync" is a maintenance task with no enforcement; it will drift.
- **A generation script that renders tool-specific files from a template at
  commit time** - rejected for this template's current scale: adds a
  build step and a new failure mode (stale generated file committed, script
  not run) for a problem thin static pointer files already solve with zero
  moving parts. Worth reconsidering only if tool-specific files ever need
  content beyond a pointer (e.g. Cursor-specific glob-scoped rules) - at
  that point, generation becomes the better trade and deserves its own ADR.
- **No adapter files, rely on each tool's docs telling users to point it at
  `.ai/AGENTS.md` manually** - rejected: several tools (Claude Code,
  Copilot) auto-discover a specific filename/location; not providing that
  file means the tool falls back to no project context at all, silently.

## Consequences

- **Easier:** one file to update when a rule changes; every tool sees the
  same rule the next time it reads its adapter.
- **Harder:** a tool-specific capability that genuinely needs tool-specific
  syntax (e.g. Cursor's glob-scoped `.mdc` rules) requires a deliberate
  decision about whether that content still counts as "canonical" or is
  legitimately tool-specific - handled case by case, defaulting to still
  keeping the substance in `.ai/` and only the syntax wrapper in the adapter.
- **Forecloses:** editing `.cursor/`, `.claude/`, or
  `.github/copilot-instructions.md` directly to add a project rule - that's
  always a sign the edit belongs in `.ai/` instead.

## How this changes agent behavior

Any agent, on any surface, that considers adding a project instruction
must add it to `.ai/AGENTS.md` (or the relevant file under `.ai/`), never
to a tool-specific adapter file directly.
