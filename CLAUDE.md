# Claude Code entry point

Canonical instructions for this repository live in
[`.ai/AGENTS.md`](.ai/AGENTS.md) - read that file, not this one, for actual
rules. This file exists only because Claude Code looks for `CLAUDE.md` at
the repo root; keep it a pointer, never add project rules here directly
(see [ADR-0005](docs/adr/ADR-0005-ai-single-source-of-truth.md)).

Project skills under [`.claude/skills/`](.claude/skills/) wrap
[`.ai/agents/`](.ai/agents/) - the pipeline stages, not duplicate content.
