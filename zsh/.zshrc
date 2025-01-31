FULL_PATH="$PATH:$HOME/.local/bin"
export PATH="$FULL_PATH"

unsetopt beep

HISTFILE=${HOME}/.cache/zsh/zsh_history
HISTSIZE=3000
SAVEHIST=3000
setopt share_history
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups

setopt menu_complete

autoload -Uz compinit && compinit -d ${HOME}/.cache/zsh/compdump
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' verbose yes

autoload -Uz colors && colors

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

source ${ZDOTDIR}/prompt_format.zsh
source ${ZDOTDIR}/keybindings.zsh
source ${ZDOTDIR}/aliases.zsh

# source <(fzf --zsh)

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ${ZDOTDIR}/plugins/zsh-syntax-highlight/zsh-syntax-highlighting.zsh
source ${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${ZDOTDIR}/plugins/zsh-tmux-autostart/zsh-tmux-autostart.zsh
source ${ZDOTDIR}/plugins/zsh-dircolors/zsh-dircolors.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=008"
