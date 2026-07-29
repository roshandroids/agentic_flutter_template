# Prompt fragment: commit message

Used by [`../agents/04-finish.md`](../agents/04-finish.md).

Generate a Conventional Commits message:

```
<type>(<scope>): <imperative summary, under 72 chars>

<1-3 bullet points: why this change, not what - the diff shows what>
```

- `type`: `feat` | `fix` | `chore` | `refactor` | `test` | `docs` | `perf`
- `scope`: the package name (`core`, `network`, `design_system`, `app`) or
  feature name for app-level changes (`app(dashboard)`).
- Never include a Jira/ticket number in the subject line - link it in the PR
  body instead, since commit subjects get surfaced in changelogs where a
  bare ticket ID is meaningless out of context.
