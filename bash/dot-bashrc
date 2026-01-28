#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "${XDG_CONFIG_HOME}/shell/aliases.sh"
source "${XDG_CONFIG_HOME}/shell/ls-colors.sh"
source "${XDG_CONFIG_HOME}/shell/man-colors.sh"
source "${XDG_CONFIG_HOME}/shell/prompt.sh"

[ -d "$XDG_CACHE_HOME/bash" ] || mkdir -p "$XDG_CACHE_HOME/bash" 
export HISTFILE=$XDG_CACHE_HOME/bash/bash_history

PROMPT_COMMAND='PS1=$(prompt_info bash)'
