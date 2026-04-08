#!/bin/bash

ROOT="${1:-$PWD}"

for d in "$ROOT"/* "$ROOT"/.*; do
  [ -d "$d" ] || continue
  bn="$(basename "$d")"
  # skip the special entries
  [ "$bn" = "." ] && continue
  [ "$bn" = ".." ] && continue

  n=$(find "$d" -type d 2>/dev/null | wc -l | tr -d ' ')
  printf "%9d  %s\n" "$n" "$d"
done | sort -nr | head -n 25