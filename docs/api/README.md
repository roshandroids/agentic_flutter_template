# API documentation

Public API documentation conventions for anything under `packages/*` that
might ship to pub.dev or be consumed by a second app.

## Convention

- Every public class/function gets a `///` dartdoc comment stating its
  contract (what it does, what it throws/returns for failure - link to the
  `Failure` subtype), not a restatement of its name.
- Generated API docs (`dart doc`) are not committed - run `dart doc` locally
  or via a future `docs` CI job once a package is public; output is
  gitignored under `doc/api/`.
- A package's `README.md` is its API's front door - usage example first,
  full API reference is `dart doc`'s job, not the README's.

## Where this differs from `architecture/`

`architecture/` explains why a package's public shape looks the way it
does; this folder is about the mechanics of documenting that public shape
once it exists (dartdoc conventions, what's committed vs. generated).
