function tmux_autostart() {
    local session_name=
    
    if [[ "$PWD" == "/" ]]; then
        session_name="root"
    elif [[ "$PWD" == "$HOME" ]]; then
        session_name="home"
    else
        session_name=${PWD##*/}
    fi

    if [[ -n "$session_name" ]]; then
        tmux new-session -s "$session_name"
    else
        tmux new-session
    fi

}

if [[ -z "$TMUX" && -z "$VIM" ]]; then
    if ! tmux has-session 2>/dev/null; then
        tmux_autostart 
    fi
fi
