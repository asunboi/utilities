#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_JSON="$SCRIPT_DIR/workspace.json"
TRACK="$SCRIPT_DIR/track.sh"
SESSION_NAME="${1:-work}"

if [ ! -f "$WORKSPACE_JSON" ]; then
    echo "No workspace.json found at $WORKSPACE_JSON"
    exit 1
fi

# Detect compute node
node=$(squeue -u "$USER" -h -o %N 2>/dev/null | head -1)
if [ -z "$node" ]; then
    echo "No active Slurm allocation found. Request a node first."
    exit 1
fi

echo "Reconnecting panes to $node..."

# Iterate over each pane entry in the JSON
jq -r 'to_entries[] | "\(.key)\t\(.value.cmd)\t\(.value.dir)"' "$WORKSPACE_JSON" | \
while IFS=$'\t' read -r pane_id cmd dir; do
    # Check that this pane still exists in the tmux session
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        echo "tmux session '$SESSION_NAME' not found"
        exit 1
    fi

    if tmux list-panes -t "$SESSION_NAME" -F '#{pane_id}' | grep -qF "$pane_id"; then
        echo "  $pane_id → cd $dir && $cmd"
        tmux send-keys -t "$pane_id" "ssh $node -t 'cd $dir && $TRACK $cmd'" Enter
    else
        echo "  $pane_id — pane no longer exists, skipping"
    fi
done

echo "Done."
