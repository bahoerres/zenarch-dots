# -----------------------------------------------------
# FISH SHELL CONFIGURATION
# -----------------------------------------------------

# Initialize 1Password
if command -v op >/dev/null
    echo "1Password CLI is available. Use 'load_secrets' to load API keys."
end

# Define configuration directory
set -l CONFIG_DIR ~/.config/fish

# Source modular configs in order
for config in $CONFIG_DIR/conf.d/*.fish
    source $config
end

# Add local bins to PATH
fish_add_path $HOME/.local/bin
fish_add_path /usr/lib/ccache/bin

# Initialize Starship prompt
starship init fish | source

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
