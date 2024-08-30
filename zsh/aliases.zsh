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
