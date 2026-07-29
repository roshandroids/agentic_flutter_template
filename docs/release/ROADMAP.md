# Roadmap

This template ships with no product roadmap - it's the foundation, not the
product. Once a real product is built on top of it, this file tracks
where it's headed at a level above individual sprints
([`../engineering/CURRENT_SPRINT.md`](../engineering/CURRENT_SPRINT.md)).

## Template roadmap (this repo itself)

- [x] First module wired end-to-end (`analytics`, console-logging
      default) - proved the contract → composition-root → registry →
      Playground pattern. See
      [`docs/guides/ADDING_A_MODULE.md`](../guides/ADDING_A_MODULE.md).
- [ ] First real *backend-integrated* module (Firebase or Supabase)
      validating `modules/module_contracts` against an actual third-party
      SDK, not just the console default.
- [ ] `flavors` (dev/staging/prod build flavors) once a second environment
      is actually needed.
