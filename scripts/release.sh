#!/usr/bin/env bash
# Wraps `melos version` (independent per-package semver from Conventional
# Commits - see docs/release/VERSIONING.md) and pushes the resulting tags.
# Deliberately not run automatically on merge - releasing is a decision.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

command -v melos >/dev/null 2>&1 || dart pub global activate melos

log "melos version (bumps only packages with commits since their last tag)"
(cd "$ROOT" && dart pub global run melos version)

log "Pushing tags"
git -C "$ROOT" push --follow-tags
