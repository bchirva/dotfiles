if [ "$(tty)" = "/dev/tty1" ] && [ -z "$DISPLAY" ] && [ -z "$SSH_CONNECTION" ]; then
    command -v startx >/dev/null && startx "${XDG_CONFIG_HOME}/X11/xinitrc"
fi
