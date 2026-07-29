#!/usr/bin/env bash
# Creates the next numbered ADR from .ai/templates/ADR_TEMPLATE.md and
# reminds you to index it - docs_validate.yml's CI check fails an ADR that
# isn't referenced from docs/adr/README.md or .ai/memory/decisions.md.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

TITLE="${1:-}"
if [ -z "$TITLE" ]; then
  echo "usage: ./scripts/new_adr.sh \"short title\""
  exit 64
fi

SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"

LAST=$(find "$ROOT/docs/adr" -maxdepth 1 -name 'ADR-*.md' -print \
  | sed -E 's/.*ADR-([0-9]+)-.*/\1/' | sort -n | tail -1)
LAST=${LAST:-0}
NEXT=$(printf "%04d" $((10#$LAST + 1)))

DEST="$ROOT/docs/adr/ADR-$NEXT-$SLUG.md"
sed -e "s/ADR-XXXX/ADR-$NEXT/" -e "s/<title>/$TITLE/" \
  "$ROOT/.ai/templates/ADR_TEMPLATE.md" > "$DEST"
sed -i '' -e "s/Status:\*\* Proposed | Accepted | Superseded by ADR-YYYY/Status:** Proposed/" "$DEST"
sed -i '' -e "s/Date:\*\* YYYY-MM-DD/Date:** $(date +%Y-%m-%d 2>/dev/null || echo "TODO")/" "$DEST"

echo "Created $DEST"
echo "Next: fill it in, then add a line to docs/adr/README.md's index"
echo "and (if it changes agent behavior) .ai/memory/decisions.md."
