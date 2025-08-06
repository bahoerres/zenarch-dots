# -----------------------------------------------------
# CUSTOMIZATION
# -----------------------------------------------------

# History Configuration
set -g HISTSIZE 50000
set -g fish_history_file ~/.local/share/fish/fish_history
set -g fish_history_cmd_mode '+' # Append to history

# Ignore certain commands in history
function ignorehistory --on-event fish_command_entered
    string match -qr '^(ls|ll|lt|cd|pwd|exit|clear|c)$' "$argv"
    and return 1
end

# Enhanced directory navigation behavior
set -g dirprev # Enable directory stack
set -U fish_features qmark-noglob # Better glob handling

# Key Bindings
bind \cw execute
bind \ce accept-autosuggestion
bind \cu toggle-autosuggestion
bind \cL forward-word
bind \ck up-or-search
bind \cj down-or-search
bind jj 'commandline -f kill-whole-line; commandline -f repaint'

# -----------------------------------------------------
# Zoxide Integration
# -----------------------------------------------------
if type -q zoxide
    zoxide init fish | source

    # Enhanced directory navigation
    alias cd="z"
    alias zz="z -" # Go to previous directory
    alias zi="z -i" # Interactive selection
    alias za="z -a" # Add path to database
    alias zr="z -r" # Remove path from database
    alias zl="z -l" # List all paths in database
end

# -----------------------------------------------------
# FZF Configuration
# -----------------------------------------------------
if type -q fzf
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow'
    set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1"
end

# -----------------------------------------------------
# Enhanced Directory Navigation
# -----------------------------------------------------
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# -----------------------------------------------------
# Load Starship
# -----------------------------------------------------
if type -q starship
    starship init fish | source
end

# -----------------------------------------------------
# Load Atuin
# -----------------------------------------------------
if type -q atuin
    atuin init fish | source
end
