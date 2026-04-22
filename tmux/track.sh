#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_JSON="$SCRIPT_DIR/workspace.json"

if [ $# -eq 0 ]; then
    echo "Usage: track.sh <command> [args...]"
    echo "Records the command for this tmux pane, then runs it."
    exit 1
fi

pane_id="${TMUX_PANE:-}"
if [ -z "$pane_id" ]; then
    echo "Warning: not in a tmux pane, skipping tracking" >&2
    exec "$@"
fi

# Build the full command string
cmd="$*"
dir="$PWD"

# Initialize JSON file if missing
[ -f "$WORKSPACE_JSON" ] || echo '{}' > "$WORKSPACE_JSON"

# Update the entry for this pane
jq --arg id "$pane_id" --arg cmd "$cmd" --arg dir "$dir" \
    '.[$id] = {"cmd": $cmd, "dir": $dir}' \
    "$WORKSPACE_JSON" > "$WORKSPACE_JSON.tmp" && mv "$WORKSPACE_JSON.tmp" "$WORKSPACE_JSON"

exec "$@"
