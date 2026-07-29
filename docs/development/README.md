# Development

Local environment setup and the day-to-day dev loop - distinct from
[`../engineering/`](../engineering/) (what to work on) and
[`../architecture/`](../architecture/) (why the system is shaped this way).

## Setup

```bash
./scripts/bootstrap.sh   # installs Melos, runs melos bootstrap
./scripts/doctor.sh      # verifies your toolchain against template.config.yaml
```

## Day to day

```bash
melos run analyze        # or: dart pub global run melos run analyze
melos run format
melos run test            # pure-Dart packages
melos run test:flutter    # Flutter packages + app
./scripts/verify.sh        # everything CI runs, in one command
```

Run `apps/app`: `cd apps/app && flutter run`.
Run the design-system gallery: `cd showcase && flutter run -d chrome`.

## Branching

`<type>/<ticket-id>-<slug>` (`feat/`, `fix/`, `chore/`) off `main`. See
[`../../CONTRIBUTING.md`](../../CONTRIBUTING.md) for the full workflow and
[`.ai/workflow/WORKFLOW.md`](../../.ai/workflow/WORKFLOW.md) for the
intake → merge-ready pipeline this repo actually follows.

## Environment variables / secrets

Never committed. See [`../operations/SECRETS.md`](../operations/SECRETS.md).
