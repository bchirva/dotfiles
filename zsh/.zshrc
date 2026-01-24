#**********# Common shell settings #**********#

source $XDG_CONFIG_HOME/shell/aliases.sh
source $XDG_CONFIG_HOME/shell/ssh-agent-autostart.sh
source $XDG_CONFIG_HOME/shell/tmux-autostart.sh
source $XDG_CONFIG_HOME/shell/ls-colors.sh
source $XDG_CONFIG_HOME/shell/man-colors.sh

#**********# Zsh history settings #**********#

[ -d "$XDG_CACHE_HOME/zsh" ] || mkdir -p "$XDG_CACHE_HOME/zsh"
HISTFILE=$XDG_CACHE_HOME/zsh/zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt share_history
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups

#**********# Zsh completion settings #**********#

fpath+=($ZDOTDIR/plugins/completions)

autoload -Uz colors && colors
autoload -Uz compinit && compinit -d $HOME/.cache/zsh/compdump
setopt menu_complete
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' verbose yes

#**********# Prompt #**********#

setopt prompt_subst
source $XDG_CONFIG_HOME/shell/prompt.sh
PROMPT='$(prompt_info zsh)'

#**********# Zsh plugins #**********#

source $ZDOTDIR/plugins/loader.zsh
load-plugins \
    "https://github.com/romkatv/zsh-defer" \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-syntax-highlighting" 

command -v fzf >/dev/null && load-plugins "https://github.com/Aloxaf/fzf-tab"

zsh-defer source $XDG_CONFIG_HOME/shell/version_managers.sh

source <(fzf --zsh)

#**********# Zsh keybindings #**********#

bindkey -v

bindkey '^n'  history-search-forward
bindkey '^p'  history-search-backward

bindkey '^a'  beginning-of-line
bindkey '^e'  end-of-line
bindkey 'b' backward-word
bindkey 'f' forward-word
bindkey '^b'  backward-char
bindkey '^f'  forward-char

bindkey '[3~' delete-char
bindkey '[P'  delete-char

autoload edit-command-line && zle -N edit-command-line
bindkey -M vicmd '^e' edit-command-line

#**********# Cursor shape #**********#

unsetopt beep

zmodload -s zsh/terminfo
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

function cursor_shape() {
    local -r code="$1"   
    if (( ${+terminfo[Ss]} && ${+terminfo[Se]} )); then
        echoti Ss ${code}
    else
        print -n -- "\e[${code} q"
    fi
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

function zle-keymap-select {
    case $KEYMAP in
        viins|main) cursor_shape 6 ;;  
        vicmd)      cursor_shape 2 ;;  
    esac
    zle reset-prompt
}
function zle-line-init() {
    cursor_shape 6 
}  
function zle-line-finish() {
    cursor_shape 2 
} 
