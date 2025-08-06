# -----------------------------------------------------
# Aliases
# -----------------------------------------------------

# cat is the bat!
alias cat="bat --paging=never"

# File listing (eza)
if type -q eza
    alias ls="eza -l --icons --git -a" # Default list view
    alias l="eza -l --icons --git -a" # Short alias for ls
    alias ll='eza -al --group-directories-first' # Long list with directories first
    alias la='eza -l --icons --sort=age --group-directories-first' # Long list sorted by file age with icons
    alias lt='eza -al --sort=modified' # List by modification time
    alias ld='eza -lD' # List directories only
    alias ltree="eza --tree --level=2 --icons --git" # Tree view

    # Complex listings need to be functions
    function lf
        eza -lF --color=always | string match -rv '/$'
    end

    function ldt
        eza -la --icons --git --group-directories-first --tree --level=2 --color=always | string match -r '^\.*\.'
    end

    function ldf
        eza -la --icons --git --group-directories-first --no-filesize --no-user --no-permissions --no-time --color=always | string match -r '^\.'
    end
end

# System commands
alias c='clear'
alias v='$EDITOR'
alias vim='$EDITOR'
alias shutdown='systemctl poweroff'
alias wifi='nmtui'

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gfo="git fetch origin"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# ML4W specific
alias ml4w='com.ml4w.welcome'
alias ml4w-settings='com.ml4w.dotfilessettings'
alias ml4w-hyprland='com.ml4w.hyprland.settings'
alias ml4w-options='ml4w-hyprland-setup -m options'
alias ml4w-sidebar='ags -t sidebar'
alias ml4w-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-update='~/.config/ml4w/update.sh'

# Display & Keyboard
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap de; echo "Keyboard set back to de."'

# Atuin Fixes
# bind \e\[A _atuin_bind_up
# `bind \eOA _atuin_bind_up
