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
find "$DEST_LIB" "$DEST_TEST" -depth -name '*feature_name*' -print0 | while IFS= read -r -d '' path; do
  newpath="$(dirname "$path")/$(basename "$path" | sed "s/feature_name/$NAME/g")"
  mv "$path" "$newpath"
done

log "Substituting tokens"
PASCAL="$(to_pascal_case "$NAME")"
CAMEL="$(to_camel_case "$NAME")"
# Tokens are public Dart identifiers (no leading "_") so the template
# itself analyzes cleanly - a leading underscore would make names
# library-private and break cross-file references in the scaffold.
# featureName (variable-name position, e.g. `smokeTestFeatureProvider`)
# must be substituted before feature_name - a snake_case name substituted
# into a camelCase identifier isn't valid lowerCamelCase.
find "$DEST_LIB" "$DEST_TEST" -type f -name '*.dart' -print0 | xargs -0 \
  sed -i '' -e "s/featureName/$CAMEL/g" -e "s/FeatureName/$PASCAL/g" -e "s/feature_name/$NAME/g"

log "Rewriting test imports for apps/app layout"
# Template tests use relative imports so templates/feature_template analyzes
# in place. After copy, lib/ and test/ live under different trees - switch
# to package:app imports.
find "$DEST_TEST" -type f -name '*.dart' -print0 | xargs -0 \
  sed -i '' \
    -e "s|import '../../domain/|import 'package:app/features/$NAME/domain/|g" \
    -e "s|import '../../application/|import 'package:app/features/$NAME/application/|g" \
    -e "s|import '../../presentation/|import 'package:app/features/$NAME/presentation/|g" \
    -e "s|import '../../infrastructure/|import 'package:app/features/$NAME/infrastructure/|g"

echo
echo "Created apps/app/lib/features/$NAME and apps/app/test/features/$NAME. Next steps:"
echo "  1. Fill in domain/entities, the DTO mapping, and the repository endpoint - do not leave the TODOs."
echo "  2. Bind ${CAMEL}RepositoryProvider in apps/app/lib/composition_root.dart (follow dashboardRepositoryProvider)."
echo "  3. Register a route in apps/app/lib/routing/app_router.dart and a destination in app_shell.dart."
echo "  4. Replace the skipped test stubs under test/features/$NAME/ with real tests."
