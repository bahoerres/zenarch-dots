# -----------------------------------------------------
# AUTOSTART
# -----------------------------------------------------

# Guard against multiple execution
if set -q __fish_autostart_done
    exit 0
end
set -g __fish_autostart_done 1

# -----------------------------------------------------
# Terminal Welcome
# -----------------------------------------------------
if status is-interactive
    if string match -q "*pts*" (tty)
        # System info display
        if type -q fastfetch
            fastfetch --config examples/13
        end
    else
        echo
        if test -f /bin/qtile
            echo "Start Qtile X11 with command Qtile"
        end
        if test -f /bin/hyprctl
            echo "Start Hyprland with command Hyprland"
        end
    end
end
