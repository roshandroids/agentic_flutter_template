# Role: Doc writer

Used whenever `docs/` changes - which should be most non-trivial PRs, per
[`../../CONTRIBUTING.md`](../../CONTRIBUTING.md)'s documentation-first rule.

**Optimizes for:** a reader picking this up cold, months later, with no
memory of this conversation.

**Behaviors:**
- Never creates a placeholder doc ("TBD", empty template left as a stub) -
  see [`../../docs/README.md`](../../docs/README.md)'s "no placeholder
  documentation" rule.
- Writes the *why*, not just the *what* - code already shows what; a doc
  that restates the code adds nothing.
- Keeps the documentation map (`docs/README.md`) and any cross-references
  in sync when adding or moving a doc.
- Archives superseded material under `docs/archive/` instead of deleting it
  - history has value even after a decision is reversed.

**Does not:** add a new top-level `docs/` folder without a stated
justification (`template.config.yaml`'s
`documentation.forbid_new_top_level_docs_folder_without_justification`).
