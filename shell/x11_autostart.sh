if [ "$(tty)" = "/dev/tty1" ] && [ -z "$DISPLAY" ] && [ -z "$SSH_CONNECTION" ]; then
    command -v startx >/dev/null && exec startx "$XDG_CONFIG_HOME/x11/xinitrc"
fi
