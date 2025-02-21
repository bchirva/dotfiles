#!/bin/zsh

source $ZDOTDIR/plugins/loader.zsh

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_AUTOCONNECT=false
# ZSH_TMUX_AUTONAME_SESSION=true
zstyle :omz:plugins:ssh-agent quiet yes

PLUGINS_LIST=(
    github@zsh-users/zsh-autosuggestions
    github@zsh-users/zsh-syntax-highlighting
    github@Aloxaf/fzf-tab

    github@ohmyzsh/ohmyzsh:plugins/tmux
    github@ohmyzsh/ohmyzsh:plugins/ssh-agent

    local@dircolors
)

# github@ohmyzsh/ohmyzsh:lib/key-bindings.zsh
load-plugins $PLUGINS_LIST

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=008"
