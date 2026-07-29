#!/usr/bin/env bash
# Scaffolds a new packages/* package from templates/package_template.
# Read docs/architecture/PACKAGE_STRATEGY.md before running this - only
# promote code to a package when its criteria are actually met.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "usage: ./scripts/new_package.sh <package_name>"
  exit 64
fi
if ! [[ "$NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "package name must be snake_case (a-z, 0-9, _), starting with a letter"
  exit 64
fi

DEST="$ROOT/packages/$NAME"
if [ -e "$DEST" ]; then
  echo "packages/$NAME already exists"
  exit 1
fi

log "Copying template"
cp -R "$ROOT/templates/package_template" "$DEST"

log "Renaming tokenized files"
mv "$DEST/lib/package_name.dart" "$DEST/lib/$NAME.dart"
mv "$DEST/lib/src/package_name_base.dart" "$DEST/lib/src/${NAME}_base.dart"
mv "$DEST/test/package_name_test.dart" "$DEST/test/${NAME}_test.dart"

log "Substituting tokens"
PASCAL="$(to_pascal_case "$NAME")"
# Tokens are public Dart identifiers (no leading "_") so the template
# itself analyzes cleanly under templates/package_template.
find "$DEST" -type f \( -name '*.dart' -o -name '*.yaml' \) -print0 | xargs -0 \
  sed -i '' -e "s/PackageName/$PASCAL/g" -e "s/package_name/$NAME/g"

log "Adapting pubspec for packages/ + workspace"
# Template resolves core from templates/ via ../../packages/core and has
# no resolution: workspace (it is not a workspace member). After copy,
# point at the sibling package and join the pub workspace.
sed -i '' \
  -e 's|path: ../../packages/core|path: ../core|' \
  -e '/^version:/a\
resolution: workspace' \
  "$DEST/pubspec.yaml"

echo
echo "Created packages/$NAME. Next steps:"
echo "  1. Add it to template.config.yaml's packages: list with its layer."
echo "  2. Add 'packages/$NAME' to the root pubspec.yaml's workspace: list"
echo "     (already has resolution: workspace in its own pubspec.yaml)."
echo "  3. ./scripts/bootstrap.sh to resolve it."
echo "  4. Fill in lib/src/${NAME}_base.dart - do not leave the placeholder."
