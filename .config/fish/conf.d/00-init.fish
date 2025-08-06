# -----------------------------------------------------
# Environment Setup
# -----------------------------------------------------

# Core settings
set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx TERM "xterm-256color"

# Locale settings
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

# Starship configuration
set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
set -gx STARSHIP_CACHE "$HOME/.cache/starship"
set -gx STARSHIP_GIT_SCAN_TIMEOUT 100

# FZF configuration
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1"
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

# Less colors
set -gx LESS "-R"
set -gx LESS_TERMCAP_mb (set_color -o red)
set -gx LESS_TERMCAP_md (set_color -o cyan)
set -gx LESS_TERMCAP_me (set_color normal)
set -gx LESS_TERMCAP_so (set_color -b blue yellow)
set -gx LESS_TERMCAP_se (set_color normal)
set -gx LESS_TERMCAP_us (set_color -o green)
set -gx LESS_TERMCAP_ue (set_color normal)
