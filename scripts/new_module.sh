#!/usr/bin/env bash
# Scaffolds a new modules/* module and registers it in template.config.yaml.
# See modules/README.md and docs/guides/ADDING_A_MODULE.md for the full
# contract pattern this plugs into.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "usage: ./scripts/new_module.sh <module_name>"
  exit 64
fi

AVAILABLE="$(config_list modules.available)"
if ! echo "$AVAILABLE" | grep -qx "$NAME"; then
  echo "'$NAME' is not in template.config.yaml's modules.available list."
  echo "Available: $(echo "$AVAILABLE" | tr '\n' ' ')"
  echo "Add it to modules.available first if this is a genuinely new module type."
  exit 1
fi

DEST="$ROOT/modules/$NAME"
if [ -e "$DEST" ]; then
  echo "modules/$NAME already exists"
  exit 1
fi

mkdir -p "$DEST/lib/src"
cat > "$DEST/pubspec.yaml" <<EOF
name: $NAME
description: $NAME module - implements the relevant contract(s) from modules/module_contracts.
publish_to: "none"
version: 0.1.0
resolution: workspace
environment:
  sdk: ^3.10.0

dependencies:
  module_contracts:
    path: ../module_contracts

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.0
EOF

cat > "$DEST/analysis_options.yaml" <<'EOF'
include: ../../analysis_options.yaml
EOF

cat > "$DEST/lib/$NAME.dart" <<EOF
/// Public API of the $NAME module - implements one or more contracts from
/// package:module_contracts. apps/app's composition_root.dart is the only
/// place that should import this directly.
library;

export 'src/${NAME}_module.dart';
EOF

PASCAL="$(to_pascal_case "$NAME")"
cat > "$DEST/lib/src/${NAME}_module.dart" <<EOF
// TODO: implement the module_contracts interface this module provides,
// e.g. \`class ${PASCAL}Module implements AuthModule { ... }\` - pick the
// contract matching what this module actually does (Auth/Analytics/
// Notifications/Payments), not necessarily one named after this module.
EOF

echo
echo "Created modules/$NAME."
echo "Next steps:"
echo "  1. Implement the contract in lib/src/${NAME}_module.dart"
echo "  2. Add '$NAME' to template.config.yaml's modules.enabled list, and"
echo "     'modules/$NAME' to the root pubspec.yaml's workspace: list, by hand"
echo "     (YAML list edits are left manual on purpose - no surprises)."
echo "  3. Wire it in apps/app/lib/composition_root.dart."
echo "  4. ./scripts/doctor.sh should now report it OK."
