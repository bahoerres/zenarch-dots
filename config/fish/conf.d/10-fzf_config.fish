# ~/.config/fish/config.fish or ~/.config/fish/functions/fzf_setup.fish

# Set fzf options
set -x FZF_DEFAULT_OPTS '--height 70% --reverse --border'

# Search history
bind \cr '_fzf_search_history'

# File search
bind \cf '_fzf_search_files'

# Directory navigation
bind \co '_fzf_search_directory'

function _fzf_search_history
    history | fzf --no-sort | read -l command
    if test $command
        commandline -f repaint
        commandline -r $command
    end
end

function _fzf_search_files
    fd --type f --hidden --follow --exclude .git | \
    fzf --preview 'bat --style=numbers --color=always {}' | \
    read -l result
    if test $result
        commandline -r "nvim $result"
        commandline -f execute
    end
end

function _fzf_search_directory
    fd --type d --hidden --follow --exclude .git | \
    fzf --preview 'tree -C {} | head -100' | \
    read -l result
    if test $result
        cd $result
    end
end
