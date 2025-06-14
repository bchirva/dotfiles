alias hist="cat ${HISTFILE} | head -n -1"
alias ls="ls --color=always --human-readable --group-directories-first"
alias grep="grep --color=always"
alias tree="tree -C"
alias less="less -r"
alias df="df -h"

alias pip='function _pip(){
    if [ $1 = "search" ]; then
        pip_search "$2";
    else pip "$@";
    fi;
};_pip'

alias cdf="cd \$(find . \( \
-path '*/.git' -o \
-path '*/node_modules' -o \
-path '*/.ccache' -o \
-path '*/__pycache__' \
\) -prune -o -type d -print | fzf)"

alias lazygit='lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme.yml"'
alias lgit='lazygit'
alias ldock="lazydocker"
alias yz="yazi"
