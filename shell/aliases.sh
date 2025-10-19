alias hist="cat ${HISTFILE} | head -n -1"
alias ls="ls --color=always --human-readable --group-directories-first"
alias grep="grep --color=always"
alias tree="tree -C"
alias less="less --raw-control-chars"
alias df="df --human-readable"
alias du="du --human-readable --max-depth=1"
alias mv="mv --interactive"
alias rm="rm --interactive"
alias lazygit="lazygit --use-config-file=\"${XDG_CONFIG_HOME}/lazygit/config.yml,${XDG_CONFIG_HOME}/lazygit/theme.yml\""
alias lgit="lazygit"
alias ldock="lazydocker"
alias yz="yazi"
alias hl="bat -l conf --style=plain --paging=never"

alias yayfzf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:80% | xargs -ro yay -S"

command -v nvim >/dev/null && alias vim="nvim"


