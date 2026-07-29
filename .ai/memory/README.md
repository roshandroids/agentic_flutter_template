# Repo-level AI memory

Durable knowledge about *this repository* that any agent, on any tool,
should load before working here. This is distinct from a tool's own private
session memory (e.g. Claude Code's per-user memory store) - this memory
belongs to the repo, travels with `git clone`, and is meant to be read and
updated by whichever agent is working, regardless of which AI tool it is.

| File | What goes here |
|---|---|
| [`decisions.md`](decisions.md) | One-line pointers to ADRs that changed how agents should behave - not the ADRs themselves (those live in `docs/adr/`), just the index entry so an agent doesn't have to read every ADR to know if one is behaviorally relevant. |
| [`glossary.md`](glossary.md) | Domain terms specific to this product that aren't obvious from code (e.g. what "merge field" means in this codebase, if this were Document Platform). |
| [`gotchas.md`](gotchas.md) | Non-obvious constraints that have caused real mistakes before - a workaround for a platform bug, a library quirk, a rule that looks unnecessary until you know why. |

## Update discipline

Add an entry when something surprised an agent or a reviewer corrected an
agent's approach for a non-obvious reason. Don't add entries derivable from
reading the code - that's what the code is for.
