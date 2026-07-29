#!/usr/bin/env bash
# Checks the local toolchain against what template.config.yaml actually
# declares this repo needs - not a generic "is Flutter installed" check.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

fail=0

check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "OK   - $label"
  else
    echo "FAIL - $label"
    fail=1
  fi
}

check "flutter on PATH" command -v flutter
check "dart on PATH" command -v dart
check "melos on PATH (or activate: dart pub global activate melos)" command -v melos

echo
echo "Platforms declared in template.config.yaml:"
for p in $(config_list platforms); do
  case "$p" in
    android) check "  android toolchain (adb)" command -v adb ;;
    ios) check "  ios toolchain (xcodebuild)" command -v xcodebuild ;;
    web) echo "  web - no extra toolchain required" ;;
    macos|windows|linux) echo "  $p - build via 'flutter build $p' when needed" ;;
  esac
done

echo
echo "Modules enabled in template.config.yaml:"
enabled="$(config_list modules.enabled || true)"
if [ -z "$enabled" ]; then
  echo "  (none enabled)"
else
  for m in $enabled; do
    if [ -d "$ROOT/modules/$m" ]; then
      echo "OK   - modules/$m exists"
    else
      echo "FAIL - modules/$m is enabled in config but the directory is missing - run ./scripts/new_module.sh $m"
      fail=1
    fi
  done
fi

echo
echo "Reconciling template.config.yaml packages against pubspec.yaml's workspace list:"
workspace_members="$(sed -n '/^workspace:/,/^[^ -]/p' "$ROOT/pubspec.yaml" | grep '^  - ' | sed 's/^  - //')"
while read -r name path layer; do
  if echo "$workspace_members" | grep -qx "$path"; then
    echo "OK   - $path (template.config.yaml) is a registered workspace member"
  else
    echo "FAIL - $path is in template.config.yaml's packages: list but missing from"
    echo "       pubspec.yaml's workspace: list - it won't resolve. Add it by hand."
    fail=1
  fi
done < <(config_packages)

echo
if [ "$fail" -ne 0 ]; then
  echo "doctor found problems above."
  exit 1
else
  echo "Toolchain looks ready."
fi
