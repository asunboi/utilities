#!/usr/bin/env bash
# This file does not do anything by itself — it just defines functions.
# call by source "$HOME/utilities/lib.sh"

set -euo pipefail

log() {
    echo "==> $*"
}

ensure_dir() {
    mkdir -p "$1"
}

ensure_line_in_file() {
    local line="$1"
    local file="$2"

    if grep -Fxq "$line" "$file" 2>/dev/null; then
        return
    fi

    echo "" >> "$file"
    echo "$line" >> "$file"
}

install_from_script() {
    local url="$1"
    local dest="$2"
    local binary="$3"

    if [[ -x "$dest/$binary" ]]; then
        log "$binary already installed"
        return
    fi

    curl -sfL "$url" | bash -s -- "$dest"
}