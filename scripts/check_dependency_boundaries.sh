#!/usr/bin/env bash
# Enforces docs/architecture/DEPENDENCY_RULES.md. Reads the package -> layer
# mapping from template.config.yaml (via tools/repo_tools) instead of
# hardcoding package names, so adding a package to the config is enough to
# get boundary enforcement - this script doesn't need editing.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

fail=0

check_no_match() {
  local label="$1" path="$2" pattern="$3"
  if [ ! -d "$path" ]; then
    return
  fi
  if grep -rlE --include='*.dart' "$pattern" "$path/lib" 2>/dev/null | grep -q .; then
    echo "FAIL: $label - forbidden imports found:"
    grep -rnE --include='*.dart' "$pattern" "$path/lib" 2>/dev/null
    fail=1
  else
    echo "OK: $label"
  fi
}

while read -r name path layer; do
  case "$layer" in
    domain)
      check_no_match "$name (domain) has zero Flutter imports" "$ROOT/$path" "package:flutter"
      ;;
    infrastructure)
      check_no_match "$name (infrastructure) does not import design_system" "$ROOT/$path" "package:design_system"
      ;;
    presentation)
      check_no_match "$name (presentation) does not import network/local_storage directly" "$ROOT/$path" "package:network|package:local_storage"
      ;;
  esac
done < <(config_packages)

exit "$fail"
