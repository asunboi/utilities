#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

usage() {
  echo "Usage: $(basename "$0") [TARGET_DIR]" >&2
  echo "  Merge missing files and directories from template/ into TARGET_DIR (default: .)." >&2
  echo "  Existing paths are never overwritten." >&2
}

path_kind() {
  local p="$1"
  if [[ -L "$p" ]]; then
    echo symlink
  elif [[ -d "$p" ]]; then
    echo directory
  elif [[ -f "$p" ]]; then
    echo file
  elif [[ -e "$p" ]]; then
    echo other
  else
    echo missing
  fi
}

# Return false if any path prefix of rel under TARGET exists and is not a directory.
ancestors_ok_for_add() {
  local rel="$1"
  local acc=""
  local d rest="$rel"
  while [[ "$rest" == */* ]]; do
    d="${rest%%/*}"
    rest="${rest#*/}"
    acc="${acc:+$acc/}$d"
    local node="$TARGET/$acc"
    if [[ -e "$node" || -L "$node" ]] && [[ ! -d "$node" ]]; then
      echo "Warning: cannot add '$rel' because '$acc' exists and is not a directory; skipping." >&2
      return 1
    fi
  done
  return 0
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -gt 1 ]]; then
  echo "Error: too many arguments" >&2
  usage
  exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "Error: template directory not found: $TEMPLATE_DIR" >&2
  exit 1
fi

TARGET="${1:-.}"
if [[ ! -e "$TARGET" ]]; then
  mkdir -p "$TARGET"
fi
if [[ ! -d "$TARGET" ]]; then
  echo "Error: target is not a directory: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

added_dirs=0
added_files=0
skipped_existing=0
warnings=0

while IFS= read -r rel; do
  [[ -z "$rel" ]] && continue
  src="$TEMPLATE_DIR/$rel"
  dst="$TARGET/$rel"

  t_kind="$(path_kind "$src")"
  if [[ "$t_kind" == "missing" ]]; then
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    d_kind="$(path_kind "$dst")"
    if [[ "$t_kind" != "$d_kind" ]]; then
      echo "Warning: type mismatch for '$rel' (template: $t_kind, target: $d_kind); skipping." >&2
      warnings=$((warnings + 1))
    else
      skipped_existing=$((skipped_existing + 1))
    fi
    continue
  fi

  if ! ancestors_ok_for_add "$rel"; then
    warnings=$((warnings + 1))
    continue
  fi

  case "$t_kind" in
    directory)
      mkdir -p "$dst"
      added_dirs=$((added_dirs + 1))
      ;;
    symlink|file)
      mkdir -p "$(dirname "$dst")"
      cp -P -- "$src" "$dst"
      added_files=$((added_files + 1))
      ;;
    other)
      mkdir -p "$(dirname "$dst")"
      cp -P -- "$src" "$dst"
      added_files=$((added_files + 1))
      ;;
  esac
done < <(find "$TEMPLATE_DIR" -mindepth 1 -printf '%P\n' | LC_ALL=C sort)

echo "Done: added_dirs=$added_dirs added_files=$added_files skipped_existing=$skipped_existing warnings=$warnings"
