# Glossary

Terms specific to this template that aren't self-evident from code alone.

- **Module** — a pluggable backend/platform integration under `modules/`
  (Firebase, Supabase, Serverpod, Auth, Analytics, Notifications, Payments).
  Not the same as a `packages/` package: a module implements a contract from
  `modules/module_contracts` and can be swapped or removed without touching
  feature code. See [`modules/README.md`](../../modules/README.md).
- **Layer** — one of domain / application / infrastructure / presentation
  within a feature. See
  [`docs/architecture/ARCHITECTURE.md`](../../docs/architecture/ARCHITECTURE.md).
- **Extraction candidate** — feature code deliberately written so it *could*
  become a `packages/` package later, without being prematurely extracted
  today. See [`docs/adr/`](../../docs/adr) for extraction ADRs once any exist.
