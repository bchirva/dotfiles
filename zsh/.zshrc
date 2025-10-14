unsetopt beep
autoload -Uz colors && colors

# History settings
HISTFILE=${HOME}/.cache/zsh/zsh_history
HISTSIZE=3000
SAVEHIST=3000
setopt share_history
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt prompt_subst

# Completion settings
fpath+=($ZDOTDIR/plugins/completions)
setopt menu_complete
autoload -Uz compinit && compinit -d ${HOME}/.cache/zsh/compdump
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' verbose yes

source ${XDG_CONFIG_HOME}/shell/prompt.sh
PROMPT='$(prompt_info zsh)'

source ${XDG_CONFIG_HOME}/shell/aliases.sh
source ${XDG_CONFIG_HOME}/shell/ssh-agent-autostart.sh
source ${XDG_CONFIG_HOME}/shell/tmux-autostart.sh
source ${XDG_CONFIG_HOME}/shell/ls-colors.sh
source ${XDG_CONFIG_HOME}/shell/man-colors.sh
source ${ZDOTDIR}/keybindings.zsh
source ${ZDOTDIR}/plugins.zsh

zsh-defer source ${XDG_CONFIG_HOME}/shell/version_managers.sh

source <(fzf --zsh)
