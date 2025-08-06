# -----------------------------------------------------
# FISH SHELL CONFIGURATION
# -----------------------------------------------------
# Define configuration directory
set -l CONFIG_DIR ~/.config/fish

# Starship configuration
set -gx STARSHIP_CONFIG "$HOME/starship.toml"

# Source modular configs in order
for config in $CONFIG_DIR/conf.d/*.fish
    source $config
end

# Add local bins to PATH
fish_add_path $HOME/.local/bin
fish_add_path /usr/lib/ccache/bin

# Initialize Starship prompt
starship init fish | source

# Initialize Atuin
# atuin init fish | source
