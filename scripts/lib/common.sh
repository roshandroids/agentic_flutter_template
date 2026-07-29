#!/usr/bin/env bash
# Sourced by every script under scripts/ - resolves the repo root and
# provides thin wrappers around tools/repo_tools' config.dart so no script
# hardcodes a template.config.yaml value.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_TOOL="$ROOT/tools/repo_tools/bin/config.dart"
CONFIG_PKG_DIR="$ROOT/tools/repo_tools"

_ensure_config_tool_ready() {
  if [ ! -d "$CONFIG_PKG_DIR/.dart_tool" ]; then
    (cd "$CONFIG_PKG_DIR" && dart pub get >/dev/null)
  fi
}

config_get() {
  _ensure_config_tool_ready
  dart run "$CONFIG_TOOL" get "$1"
}

config_list() {
  _ensure_config_tool_ready
  dart run "$CONFIG_TOOL" list "$1"
}

config_packages() {
  _ensure_config_tool_ready
  dart run "$CONFIG_TOOL" packages
}

log() { echo "==> $*"; }

# snake_case -> PascalCase, without relying on GNU sed's `\U` (BSD/macOS
# sed doesn't support it - it's a GNU extension) or bash 4's `${var^}`
# case-expansion (macOS ships bash 3.2, which doesn't support it either).
# Portable across both via plain `tr` per underscore-delimited segment.
to_pascal_case() {
  local input="$1" result="" part first rest
  local oldifs="$IFS"
  IFS='_'
  for part in $input; do
    first="$(printf '%s' "${part:0:1}" | tr '[:lower:]' '[:upper:]')"
    rest="${part:1}"
    result="${result}${first}${rest}"
  done
  IFS="$oldifs"
  printf '%s' "$result"
}

# snake_case -> camelCase - same portability rationale as to_pascal_case.
to_camel_case() {
  local pascal first rest
  pascal="$(to_pascal_case "$1")"
  first="$(printf '%s' "${pascal:0:1}" | tr '[:upper:]' '[:lower:]')"
  rest="${pascal:1}"
  printf '%s' "${first}${rest}"
}
