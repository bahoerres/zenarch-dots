# Save as ~/.config/fish/functions/ya.fish
function ya
    set -l tmp (mktemp -t "yazi-cwd.XXXXX")
    yazi $argv --cwd-file="$tmp"
    if test -f $tmp
        set -l cwd (cat -- "$tmp")
        if test -n "$cwd" -a "$cwd" != "$PWD"
            cd -- "$cwd"
        end
    end
    rm -f -- "$tmp"
end

# Save as ~/.config/fish/functions/bh.fish
function bh
    set -l topic $argv[1]
    if test -z "$topic"
        set topic "menu"
    end
    
    switch $topic
        case "fzf"
            echo "🔍 FZF Quick Reference:
            
            Navigation:
            fcd     - fuzzy cd into directory
            ff      - fuzzy find file and copy path
            fv      - fuzzy find and open in neovim
            
            In FZF:
            ctrl-j/k    - move up/down
            ctrl-space  - toggle selection
            enter      - confirm
            esc        - cancel"
        # ... [rest of your bh cases]
    end
end

# Save as ~/.config/fish/functions/cx.fish
function cx
    cd $argv && eza -la --icons
end

# Save as ~/.config/fish/functions/fcd.fish
function fcd
    set -l dir (fd -t d | fzf --preview 'eza -la --icons {}' --preview-window=right:50%)
    if test -n "$dir"
        cd "$dir" && eza -la --icons
    end
end

# Save as ~/.config/fish/functions/ff.fish
function ff
    set -l file (fd -t f | fzf --preview 'bat --color=always {}' --preview-window=right:60%)
    if test -n "$file"
        echo "$file" | wl-copy
    end
end

# Save as ~/.config/fish/functions/fv.fish
function fv
    set -l file (fd -t f | fzf --preview 'bat --color=always {}' --preview-window=right:60%)
    if test -n "$file"
        $EDITOR "$file"
    end
end
