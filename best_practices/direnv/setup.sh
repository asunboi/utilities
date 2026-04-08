#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

echo "==> Setting up direnv in $BIN_DIR"

mkdir -p "$BIN_DIR"

install_direnv() {
    if [[ -x "$BIN_DIR/direnv" ]]; then
        echo "direnv already installed at $BIN_DIR/direnv"
        return
    fi

    echo "Installing direnv to $BIN_DIR..."
    curl -sfL https://direnv.net/install.sh | bash -s -- "$BIN_DIR"
}

ensure_line_in_bashrc() {
    local line="$1"
    if grep -Fxq "$line" "$BASHRC"; then
        echo "Already present in ~/.bashrc: $line"
    else
        echo "Adding to ~/.bashrc: $line"
        echo "" >> "$BASHRC"
        echo "$line" >> "$BASHRC"
    fi
}

install_direnv

echo "==> Ensuring ~/.local/bin is on PATH"
ensure_line_in_bashrc 'export PATH="$HOME/.local/bin:$PATH"'

echo "==> Configuring conda + prompt behavior"
ensure_line_in_bashrc 'export CONDA_CHANGEPS1=false'
ensure_line_in_bashrc "PS1='\${CONDA_DEFAULT_ENV:+(\$CONDA_DEFAULT_ENV)}[\\u@\\h \\W]\\\\$ '"

echo "==> Enabling direnv hook (should come after other prompt modifiers)"
ensure_line_in_bashrc 'eval "$(direnv hook bash)"'

echo "==> Done"
echo "Reload with: source ~/.bashrc"