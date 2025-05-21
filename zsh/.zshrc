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

# Completion settings
fpath+=($ZDOTDIR/plugins/completions)
setopt menu_complete
autoload -Uz compinit && compinit -d ${HOME}/.cache/zsh/compdump
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' verbose yes

# Plugins
source ${ZDOTDIR}/aliases.zsh
source ${ZDOTDIR}/keybindings.zsh
source ${ZDOTDIR}/prompt_format.zsh
source ${ZDOTDIR}/plugins.zsh
zsh-defer source ${ZDOTDIR}/environment_variables.zsh

# source <(fzf --zsh)

