#!/usr/bin/env bash
# Removes build artifacts and generated code across the workspace - for
# when a stale .dart_tool/build cache is the suspect behind a weird error.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

log "flutter clean in every Flutter package/app"
while read -r _ path layer; do
  case "$layer" in
    infrastructure|presentation) ;; # may be Flutter, harmless to try either way
  esac
  [ -f "$ROOT/$path/pubspec.yaml" ] || continue
  if grep -q 'flutter:' "$ROOT/$path/pubspec.yaml"; then
    (cd "$ROOT/$path" && flutter clean >/dev/null 2>&1 || true)
  fi
done < <(config_packages)
(cd "$ROOT/apps/app" && flutter clean >/dev/null 2>&1 || true)
(cd "$ROOT/showcase" && flutter clean >/dev/null 2>&1 || true)

log "Removing generated code (*.g.dart, *.freezed.dart, *.gr.dart, *.mocks.dart)"
find "$ROOT" -type f \( -name '*.g.dart' -o -name '*.freezed.dart' -o -name '*.gr.dart' -o -name '*.mocks.dart' \) \
  -not -path '*/.dart_tool/*' -delete

log "Removing coverage output"
find "$ROOT" -type d -name coverage -not -path '*/.dart_tool/*' -exec rm -rf {} + 2>/dev/null || true

echo "Clean. Run ./scripts/bootstrap.sh then ./scripts/generate.sh before building again."
