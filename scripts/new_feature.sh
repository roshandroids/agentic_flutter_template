#!/usr/bin/env bash
# Scaffolds a new feature's four layers under apps/app, from
# templates/feature_template - the exact shape the dashboard feature
# already uses. See docs/guides/NEW_FEATURE.md.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "usage: ./scripts/new_feature.sh <feature_name>"
  exit 64
fi
if ! [[ "$NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "feature name must be snake_case (a-z, 0-9, _), starting with a letter"
  exit 64
fi

APP="$ROOT/apps/app"
DEST_LIB="$APP/lib/features/$NAME"
DEST_TEST="$APP/test/features/$NAME"

if [ -e "$DEST_LIB" ]; then
  echo "apps/app/lib/features/$NAME already exists"
  exit 1
fi

log "Copying feature template"
mkdir -p "$DEST_LIB"
cp -R "$ROOT/templates/feature_template/domain" \
      "$ROOT/templates/feature_template/application" \
      "$ROOT/templates/feature_template/infrastructure" \
      "$ROOT/templates/feature_template/presentation" \
      "$DEST_LIB/"
cp -R "$ROOT/templates/feature_template/test" "$DEST_TEST"

log "Renaming tokenized files"
find "$DEST_LIB" "$DEST_TEST" -depth -name '*__feature__*' -print0 | while IFS= read -r -d '' path; do
  newpath="$(dirname "$path")/$(basename "$path" | sed "s/__feature__/$NAME/g")"
  mv "$path" "$newpath"
done

log "Substituting tokens"
PASCAL="$(to_pascal_case "$NAME")"
CAMEL="$(to_camel_case "$NAME")"
# __featureCamel__ (variable-name position, e.g. `smokeTestFeatureProvider`)
# must be substituted before __feature__ - a snake_case name substituted
# directly into a variable name (`smoke_test_featureProvider`) isn't valid
# lowerCamelCase, which is exactly the bug this token exists to avoid.
find "$DEST_LIB" "$DEST_TEST" -type f -name '*.dart' -print0 | xargs -0 \
  sed -i '' -e "s/__featureCamel__/$CAMEL/g" -e "s/__feature__/$NAME/g" -e "s/__Feature__/$PASCAL/g"

echo
echo "Created apps/app/lib/features/$NAME and apps/app/test/features/$NAME. Next steps:"
echo "  1. Fill in domain/entities, the DTO mapping, and the repository endpoint - do not leave the TODOs."
echo "  2. Bind ${CAMEL}RepositoryProvider in apps/app/lib/composition_root.dart (follow dashboardRepositoryProvider)."
echo "  3. Register a route in apps/app/lib/routing/app_router.dart and a destination in app_shell.dart."
echo "  4. Replace the skipped test stubs under test/features/$NAME/ with real tests."
