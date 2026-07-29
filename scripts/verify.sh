#!/usr/bin/env bash
# Runs exactly what CI runs, in one command, so a green local run means a
# green PR. See .github/workflows/{format,analyze,dependency_validate,
# test,coverage}.yml - this script and those workflows must stay in sync.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

command -v melos >/dev/null 2>&1 || dart pub global activate melos

log "Format check"
dart format --set-exit-if-changed "$ROOT"

log "Analyze"
(cd "$ROOT" && dart pub global run melos run analyze)

log "Dependency boundaries"
"$ROOT/scripts/check_dependency_boundaries.sh"

log "Test (pure-Dart packages)"
(cd "$ROOT" && dart pub global run melos run test)

log "Test (Flutter packages + app, excluding golden)"
(cd "$ROOT" && dart pub global run melos exec --dir-exists=test --flutter -- flutter test --exclude-tags=golden)

log "Coverage gate"
"$ROOT/scripts/check_coverage.sh"

echo
echo "verify.sh passed - matches what CI checks."
