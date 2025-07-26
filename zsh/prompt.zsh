source ${XDG_CONFIG_HOME}/shell/theme.sh
source ${XDG_CONFIG_HOME}/shell/prompt.sh

setopt prompt_subst
PROMPT='$(prompt_info zsh)'
