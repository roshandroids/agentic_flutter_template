# Security Policy

## Reporting a vulnerability

Do **not** open a public issue for a suspected security vulnerability.

Instead, use GitHub's [private vulnerability reporting](../../security/advisories/new)
for this repository, or email the maintainer listed in `.github/CODEOWNERS`.
Include:

- A description of the vulnerability and its impact.
- Steps to reproduce (minimal repro if possible).
- Affected package(s)/version(s) - this is a monorepo, so name the package
  (`packages/network`, `apps/app`, etc.), not just "the app".

You should expect an initial response within 5 business days.

## Supported versions

Only the `main` branch and the latest published version of each `packages/*`
package receive security fixes. See [docs/release/VERSIONING.md](docs/release/VERSIONING.md).

## Secrets

This repo never commits real secrets. `.env`, keystores, and Google
Services config files are gitignored - see [docs/operations/SECRETS.md](docs/operations/SECRETS.md)
for how secrets are actually supplied in CI and local dev.
