function _tmux_autostart() {
    WORDS_FILE="/usr/share/dict/words"
    if [ -f "$WORDS_FILE" ]; then
        tmux new-session -s "$(shuf -n 1 "$WORDS_FILE" | sed 's/.*/\L&/g')" 
    else
        tmux new-session
    fi
}

if command -v tmux >/dev/null ; then 
	export PATH="${HOME}/.config/tmux/plugins/tmuxifier/bin:${PATH}"

    if command -v tmuxifier >/dev/null; then
    	eval "$(tmuxifier init -)"
    fi

    if [ -z "$TMUX" ] && [ -z "$VIM" ] && [ -z "$SSH_CONNECTION" ] && [ -n "$DISPLAY" ]; then
		_tmux_autostart 
	fi
fi
