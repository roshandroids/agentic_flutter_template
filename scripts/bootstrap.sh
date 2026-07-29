#!/usr/bin/env bash
# First-time setup: installs Melos if missing, then links every local
# package to every other local package. Run this once after cloning, and
# again any time a pubspec changes.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

if ! command -v melos >/dev/null 2>&1; then
  log "melos not found - activating globally"
  dart pub global activate melos
fi

log "Resolving dependencies for tools/repo_tools"
(cd "$ROOT/tools/repo_tools" && dart pub get)

log "melos bootstrap"
(cd "$ROOT" && dart pub global run melos bootstrap)

log "Bootstrap complete. Next: ./scripts/doctor.sh"
