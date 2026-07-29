# Prompt fragment: writing an ADR

Used by [`../roles/architect.md`](../roles/architect.md) and
`./scripts/new_adr.sh`.

Fill every section of [`../templates/ADR_TEMPLATE.md`](../templates/ADR_TEMPLATE.md) -
an ADR with an empty "Alternatives considered" section is not an ADR, it's a
decision announcement. Specifically:

- **Context**: the constraint or problem that forced a decision, not a
  restatement of the feature request.
- **Decision**: one sentence, unambiguous.
- **Alternatives considered**: at least one real alternative, with the
  specific reason it was rejected (not "was less good").
- **Consequences**: what this makes easier, what it makes harder, and what
  it forecloses.
- **How AI agents should interact with this**: if the decision changes a
  rule an agent must follow (a new boundary, a new required pattern), say so
  explicitly - this is what keeps [`../AGENTS.md`](../AGENTS.md) accurate.
