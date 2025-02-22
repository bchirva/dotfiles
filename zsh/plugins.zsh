source $ZDOTDIR/plugins/loader.zsh

PLUGINS_LIST=(
    github@romkatv/zsh-defer
    github@zsh-users/zsh-autosuggestions
    github@zsh-users/zsh-syntax-highlighting
    github@Aloxaf/fzf-tab

    local@dircolors
    local@tmux-autostart
    local@ssh-agent-autostart
)

load-plugins $PLUGINS_LIST

