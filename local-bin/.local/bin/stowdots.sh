#!/bin/bash

set -euo pipefail

# Utility functions
log() { echo ">>> $1"; }
error() { echo "ERROR: $1" >&2; exit 1; }

check_prereqs() {
    command -v stow >/dev/null 2>&1 || error "GNU Stow required"
    command -v git >/dev/null 2>&1 || error "Git required"
    command -v gh >/dev/null 2>&1 || error "GitHub CLI required"
    command -v paru >/dev/null 2>&1 || error "Paru required"
}

# Config locations struct
declare -A PATHS=(
["config"]="$HOME/.config"
["local_bin"]="$HOME/.local/bin"
["local_share"]="$HOME/.local/share"
)

# Config items to manage
MANAGED_CONFIGS=(
    # .config items
    "ags"
    "alacritty"
    "atuin"
    "autostart"
    "bat"
    "btop"
    "cava"
    "fastfetch"
    "fish"
    "fontconfig"
    "font-manager"
    "gh"
    "gnome-session"
    "kitty"
    "lazygit"
    "ml4w"
    "nvim"
    "qt5ct"
    "qt6ct"
    "rofi"
    "starship.toml"
    "vim"
    "waybar"
    "waypaper"
    "wlogout"
    "xsettingsd"
    "zshrc"
)

# Additional paths to manage
LOCAL_SHARE_DIRS=(
    "fonts"
    "themes"
)

setup_dotfiles() {
    local dots_dir="$HOME/.dotfiles"
    local backup_timestamp=$(date +%Y%m%d_%H%M%S)

    read -p "Enter GitHub repository name: " repo_name
    [[ -z "$repo_name" ]] && error "Repository name required"

    # Process .config files
    for item in "${MANAGED_CONFIGS[@]}"; do
        if [ -e "${PATHS[config]}/$item" ]; then
            mkdir -p "$dots_dir/$item/.config"

            if [ -L "${PATHS[config]}/$item" ]; then
                real_path=$(readlink -f "${PATHS[config]}/$item")
                cp -r "$real_path" "$dots_dir/$item/.config/"
            else
                cp -r "${PATHS[config]}/$item" "$dots_dir/$item/.config/"
            fi

            rm -rf "${PATHS[config]}/$item"
            ln -s "$dots_dir/$item/.config/$item" "${PATHS[config]}/$item"
        fi
    done

    # Process .local/share directories
    for dir in "${LOCAL_SHARE_DIRS[@]}"; do
        if [ -d "${PATHS[local_share]}/$dir" ]; then
            mkdir -p "$dots_dir/local-share/.local/share"
            cp -r "${PATHS[local_share]}/$dir" "$dots_dir/local-share/.local/share/"
        fi
    done

    # Process .local/bin
    if [ -d "${PATHS[local_bin]}" ]; then
        mkdir -p "$dots_dir/local-bin/.local"
        cp -r "${PATHS[local_bin]}" "$dots_dir/local-bin/.local/"
    fi

    # Git setup
    cd "$dots_dir" || error "Cannot access dotfiles directory"
    git init

    cat > README.md << EOF
# Dotfiles

Personal configuration files managed with GNU Stow.

## Managed Configurations
$(printf '- %s\n' "${MANAGED_CONFIGS[@]}")

## Additional Resources
- ~/.local/bin scripts
- ~/.local/share/fonts
- ~/.local/share/themes

## Setup
\`\`\`bash
git clone git@github.com:USERNAME/$repo_name.git ~/.dotfiles
cd ~/.dotfiles
for dir in */; do stow -v "\${dir%/}"; done
\`\`\`
EOF

git add .
git commit -m "Initial dotfiles setup"
gh repo create "$repo_name" --private --source=. --remote=origin
git push -u origin main
}
restore_system() {
    local repo_url="$1"
    [[ -z "$repo_url" ]] && error "Repository URL required"

    git clone "$repo_url" "$HOME/.dotfiles"
    cd "$HOME/.dotfiles" || error "Cannot access dotfiles directory"

    # Install packages first
    if [ -f "packages.txt" ]; then
        paru -S --needed - < packages.txt
    fi

    # Then stow all configs
    for dir in */; do
        stow -v "${dir%/}"
    done
}

check_prereqs

case "${1:-}" in
    "init") setup_dotfiles ;;
    "restore") restore_system "$2" ;;
    *) echo "Usage: $0 {init|restore REPO_URL}" ;;
esac
