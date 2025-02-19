#!/bin/zsh

source ${ZDOTDIR}/plugins_manager.zsh

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_AUTONAME_SESSION=true
zstyle :omz:plugins:ssh-agent quiet yes

PLUGINS_LIST=(
    github@zsh-users/zsh-autosuggestions
    github@zsh-users/zsh-syntax-highlighting
    
    github@ohmyzsh/ohmyzsh:lib/key-bindings.zsh
    github@ohmyzsh/ohmyzsh:plugins/ssh-agent
    github@ohmyzsh/ohmyzsh:plugins/tmux

    local@plugins/dircolors
)

load-plugins $PLUGINS_LIST


