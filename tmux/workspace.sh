#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_JSON="$SCRIPT_DIR/workspace.json"
TRACK="$SCRIPT_DIR/track.sh"
SESSION_NAME="${1:-work}"
DEFAULT_PANES=4

# Detect compute node
node=$(squeue -u "$USER" -h -o %N 2>/dev/null | head -1)
if [ -z "$node" ]; then
    echo "No active Slurm allocation found. Request a node first."
    exit 1
fi

# Don't clobber an existing session
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "tmux session '$SESSION_NAME' already exists."
    echo "  To reconnect panes: $SCRIPT_DIR/reconnect.sh $SESSION_NAME"
    echo "  To attach: tmux -CC attach -t $SESSION_NAME"
    exit 0
fi

# Determine pane configs
if [ -f "$WORKSPACE_JSON" ] && [ "$(jq 'length' "$WORKSPACE_JSON")" -gt 0 ]; then
    pane_count=$(jq 'length' "$WORKSPACE_JSON")
    echo "Found $pane_count panes in workspace.json"
    # Extract entries as ordered array (pane IDs from old session won't match, so just use the commands)
    mapfile -t cmds < <(jq -r '[.[] | .cmd] | .[]' "$WORKSPACE_JSON")
    mapfile -t dirs < <(jq -r '[.[] | .dir] | .[]' "$WORKSPACE_JSON")
else
    pane_count=$DEFAULT_PANES
    echo "No workspace.json found, creating $pane_count default panes"
    cmds=()
    dirs=()
    for ((i = 0; i < pane_count; i++)); do
        cmds+=("bash")
        dirs+=("$HOME")
    done
fi

echo "Creating tmux session '$SESSION_NAME' with $pane_count panes → $node"

# Create session with the first pane
tmux new-session -d -s "$SESSION_NAME" -x 200 -y 50

# Create additional panes
for ((i = 1; i < pane_count; i++)); do
    tmux split-window -t "$SESSION_NAME"
done

# Even out the layout
tmux select-layout -t "$SESSION_NAME" tiled

# Send commands to each pane
pane_ids=()
mapfile -t pane_ids < <(tmux list-panes -t "$SESSION_NAME" -F '#{pane_id}')

for ((i = 0; i < pane_count; i++)); do
    pid="${pane_ids[$i]}"
    dir="${dirs[$i]}"
    cmd="${cmds[$i]}"
    tmux send-keys -t "$pid" "ssh $node -t 'cd $dir && $TRACK $cmd'" Enter
done

echo ""
echo "Session '$SESSION_NAME' ready with $pane_count panes."
echo "Attach with: tmux -CC attach -t $SESSION_NAME"
