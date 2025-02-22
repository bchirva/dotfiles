function _tmux_autostart() {
    local SESSION_NAME=
    
    if [[ "$PWD" == "/" ]]; then
        SESSION_NAME="root"
    elif [[ "$PWD" == "$HOME" ]]; then
        SESSION_NAME="home"
    else
        SESSION_NAME=${PWD##*/}
    fi

    if [[ -n "$SESSION_NAME" ]]; then
        tmux new-session -s "$SESSION_NAME"
    else
        tmux new-session
    fi
}

if [[ -z "$TMUX" && -z "$VIM" ]]; then
    if ! tmux has-session 2>/dev/null; then
        _tmux_autostart 
    fi
fi
