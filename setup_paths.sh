#!/bin/bash
# ... existing code ...

# New function for environment setup
setup_environment() {
    local shell_config
    local path_to_add="$PWD"
    
    # Detect shell and set config file
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_config="$HOME/.bashrc"
    else
        echo "Unsupported shell: $SHELL"
        return 1
    fi

    # Backup config file
    cp "$shell_config" "${shell_config}.backup.$(date +%Y%m%d_%H%M%S)"

    # Check if path is already in PATH
    if grep -q "export PATH=\"$path_to_add:\$PATH\"" "$shell_config"; then
        echo "Path already added to $shell_config"
        return 0
    fi

    # Append to config
    echo "export PATH=\"$path_to_add:\$PATH\"" >> "$shell_config"
    echo "✓ Added $path_to_add to PATH in $shell_config. Run 'source $shell_config' to apply."
}

# Call the function after project creation
# ... existing code after gh repo create ...
setup_environment

echo "✓ Project created: $PROJECT_NAME"