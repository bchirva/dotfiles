#!/bin/zsh

source $ZDOTDIR/plugins/loader.zsh

zstyle :omz:plugins:ssh-agent quiet yes

PLUGINS_LIST=(
    github@zsh-users/zsh-autosuggestions
    github@zsh-users/zsh-syntax-highlighting
    github@Aloxaf/fzf-tab

    github@ohmyzsh/ohmyzsh:plugins/ssh-agent

    local@dircolors
    local@tmux-autostart
)

load-plugins $PLUGINS_LIST

