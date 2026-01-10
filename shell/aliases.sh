alias df="df --human-readable"
alias du="du --human-readable --max-depth=1 | sort --human-numeric-sort"
alias grep="grep --color=always"
alias hl="bat -l conf --style=plain --paging=never"
alias lazygit="lazygit --use-config-file=\"$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/theme.yml\""
alias less="less --raw-control-chars"
alias lgit="lazygit"
alias ldock="lazydocker"
alias ls="ls --color=always --human-readable --group-directories-first"
alias ll="ls -lA"
alias mv="mv --interactive"
alias rm="rm --interactive"
alias tree="tree -C"
alias wget="wget --hsts-file=$XDG_STATE_HOME/wget-hsts"
alias yz="TERM='xterm-kitty' yazi"

command -v nvim >/dev/null && alias vim="nvim"

manpdf() {
    echo "$@"
    command -v zathura >/dev/null && man -Tpdf "$@" | zathura -
}
