#!/usr/bin/env bash
# Runs build_runner for every package/app that declares it (freezed,
# json_serializable, gen_l10n-adjacent codegen) - one command instead of
# remembering which packages need it.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

command -v melos >/dev/null 2>&1 || dart pub global activate melos

log "build_runner across the workspace"
(cd "$ROOT" && dart pub global run melos exec --depends-on=build_runner -- \
  dart run build_runner build --delete-conflicting-outputs)

log "flutter gen-l10n (apps/app)"
if [ -f "$ROOT/apps/app/l10n.yaml" ]; then
  (cd "$ROOT/apps/app" && flutter gen-l10n)
fi
