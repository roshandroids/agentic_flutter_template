# Documentation map

Every top-level folder here has exactly one job. Adding a new one requires
justification (`template.config.yaml`'s
`documentation.forbid_new_top_level_docs_folder_without_justification`) -
so before adding folder #14, check whether the doc actually belongs in one
of these.

| Folder | Job | Read when |
|---|---|---|
| [`architecture/`](architecture/) | The system's shape: layers, packages, coding standards, dependency rules. | Before touching structure, not features. |
| [`adr/`](adr/) | Point-in-time decision records - why a boundary or technology was chosen. | Before proposing to change something already decided; before deciding something new. |
| [`engineering/`](engineering/) | The live state of work: current sprint, next task, implementation rules. | At the start of every session - it's the "what now" doc. |
| [`development/`](development/) | Local environment setup, branch strategy, day-to-day workflow. | Onboarding, or when the dev loop itself is the problem. |
| [`product/`](product/) | What we're building and for whom - PRDs. | Before scoping a feature, to check it still matches product intent. |
| [`release/`](release/) | Versioning policy, changelog, coverage snapshot, benchmarks, roadmap. | Before cutting a release; when asked "what changed in vX". |
| [`testing/`](testing/) | The complete testing strategy - what gets which kind of test, and why. | Before writing any test, and when reviewing one. |
| [`guides/`](guides/) | Task-oriented how-tos (new feature, new package, embedding, etc.). | "How do I do X in this repo" - not "why does X work this way" (that's architecture). |
| [`reference/`](reference/) | Lookup material: config keys, script reference, package index. | When you need the exact key/flag/name, not the reasoning behind it. |
| [`api/`](api/) | Public API documentation conventions and where generated API docs land. | Before publishing a package, or documenting a new public class. |
| [`operations/`](operations/) | Deployment, secrets, monitoring, incident response. | Running or operating the shipped product, not developing it. |
| [`research/`](research/) | Pre-implementation investigation for non-trivial features. | Before implementing something with real design uncertainty. |
| [`archive/`](archive/) | Superseded material, kept for history instead of deleted. | Rarely - only when you need to know what used to be true and why it changed. |

## Rules (see [`CONTRIBUTING.md`](../CONTRIBUTING.md) for the full list)

- Never create placeholder documentation.
- Never invent implementation details a decision hasn't actually made.
- Archive, don't delete, when something is superseded.
- New top-level folder → justify it in the PR, or it belongs in an existing one.
