#!/usr/bin/env bash
# Coverage gate for pure-Dart packages (layer: domain/infrastructure with no
# Flutter dep). Threshold comes from template.config.yaml so CI and local
# runs can never disagree on the number.
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

command -v format_coverage >/dev/null 2>&1 || dart pub global activate coverage

THRESHOLD="${COVERAGE_THRESHOLD:-$(config_get testing.coverage_threshold)}"
fail=0

while read -r name path layer; do
  pkg_dir="$ROOT/$path"
  [ -d "$pkg_dir/test" ] || continue
  [ -f "$pkg_dir/pubspec.yaml" ] || continue
  if grep -q 'flutter:' "$pkg_dir/pubspec.yaml" 2>/dev/null; then
    continue # Flutter packages use flutter test's own coverage flag, not this gate
  fi

  log "Coverage: $name"
  # Pub workspaces resolve dependencies once at the workspace root - a
  # member package no longer has its own .dart_tool/package_config.json,
  # only $ROOT does. format_coverage needs pointing there explicitly.
  (
    cd "$pkg_dir"
    dart test --coverage=coverage
    dart pub global run coverage:format_coverage \
      --lcov --in=coverage --out=coverage/lcov.info \
      --packages="$ROOT/.dart_tool/package_config.json" --report-on=lib
  )

  # Sum LF (lines found) / LH (lines hit) across the lcov report ourselves -
  # avoids depending on the separate `lcov` CLI just for a percentage.
  total=$(awk -F: '
    /^LF:/ { found += $2 }
    /^LH:/ { hit += $2 }
    END { if (found > 0) printf "%.1f", (hit / found) * 100; else print "0" }
  ' "$pkg_dir/coverage/lcov.info")

  awk -v t="$total" -v th="$THRESHOLD" 'BEGIN { exit !(t+0 >= th+0) }' && \
    echo "OK: $name coverage ${total}% >= ${THRESHOLD}%" || {
      echo "FAIL: $name coverage ${total}% < ${THRESHOLD}%"
      fail=1
    }
done < <(config_packages)

exit "$fail"
