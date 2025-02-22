#!/bin/zsh

source $ZDOTDIR/plugins/loader.zsh

zstyle :omz:plugins:ssh-agent quiet yes

PLUGINS_LIST=(
    github@zsh-users/zsh-autosuggestions
    github@zsh-users/zsh-syntax-highlighting
    github@Aloxaf/fzf-tab

    local@dircolors
    local@tmux-autostart
    local@ssh-agent-autostart
)

load-plugins $PLUGINS_LIST

