#!/bin/zsh

local ANPLUGZ_PATH=$HOME/.local/share/zsh/anplugz
if [[ ! -d $ANPLUGZ_PATH ]]; then
    git clone https://github.com/bchirva/anplugz.git $ANPLUGZ_PATH
fi
source $ANPLUGZ_PATH/anplugz.zsh

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_AUTONAME_SESSION=true
zstyle :omz:plugins:ssh-agent quiet yes

PLUGINS_LIST=(
    github@zsh-users/zsh-autosuggestions
    github@zsh-users/zsh-syntax-highlighting
    github@Aloxaf/fzf-tab

    github@ohmyzsh/ohmyzsh:plugins/ssh-agent
    github@ohmyzsh/ohmyzsh:plugins/tmux

    local@dircolors
)

    # github@ohmyzsh/ohmyzsh:lib/key-bindings.zsh
load-plugins $PLUGINS_LIST

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=008"
