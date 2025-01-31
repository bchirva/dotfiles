#!/bin/zsh

alias hist="cat ${HISTFILE} | head -n -1"
alias ls="ls --color=auto -h"
alias grep="grep --color=auto"

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
