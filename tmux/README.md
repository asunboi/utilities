# tmux workspace manager

Persistent tmux workspaces for HPC nodes that come and go.

tmux runs on the login node so the pane layout survives when a compute node allocation ends. `track.sh` records what each pane is running so `reconnect.sh` can restore everything automatically.

## Scripts

| Script | When to use |
|---|---|
| `workspace.sh` | First login of the day, or after login node restart |
| `reconnect.sh` | After getting a new compute node |
| `track.sh` | Every time you launch a command you want tracked |

## Workflow

### Day start

```bash
# Request a compute node
salloc --time=8:00:00 ...

# Create the tmux workspace (detects node from squeue)
~/programs/utilities/tmux/workspace.sh

# Attach from iTerm2
tmux -CC attach -t work
```

This creates a tmux session with panes. If `workspace.json` exists from a previous day, it restores that layout. Otherwise it creates 4 empty panes.

### Start a tracked session in a pane

```bash
# Claude session
~/programs/utilities/tmux/track.sh claude --name protein-docking --resume

# Any command works
~/programs/utilities/tmux/track.sh python train.py
~/programs/utilities/tmux/track.sh bash
```

`track.sh` records the pane ID, command, and directory to `workspace.json`, then runs the command. When you start a new session in the same pane, the old entry is overwritten.

### Node dies, get a new one

```bash
# Panes show "Connection closed" but layout is intact
salloc --time=8:00:00 ...

# Reconnect all panes to the new node
~/programs/utilities/tmux/reconnect.sh
```

Each pane re-SSHes to the new node and resumes its last tracked command.

### Optional: shorter alias

Add to `.bashrc` if you don't want to type the full path:

```bash
alias t=~/programs/utilities/tmux/track.sh
alias ws=~/programs/utilities/tmux/workspace.sh
alias rc=~/programs/utilities/tmux/reconnect.sh
```

Then: `t claude --name my-task --resume`

## Files

- `workspace.json` — auto-managed, maps tmux pane IDs to last-known commands. Don't edit by hand.
- `workspace.sh` — creates tmux session + panes from scratch.
- `reconnect.sh` — re-SSHes existing panes to a new compute node.
- `track.sh` — records a pane's command, then execs it.
