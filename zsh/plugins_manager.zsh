#!/bin/zsh 

# Directory where the plugin manager downloads plugins from remote repositories (e.g., GitHub)
: ${ZSH_PLUGINS_DIR:=$HOME/.local/share/zsh/plugins}
: ${ZSH_LOCAL_PLUGINS_DIR:=$ZDOTDIR/plugins}

# Create directory if don't exist
if [[ ! -d $ZSH_PLUGINS_DIR ]]; then
    mkdir --parents $ZSH_PLUGINS_DIR
fi

# Define plugin. Argument is source@[repository:]path
# Plugin definition format examples:
#       github@user/repo for github clone
#       github@user/repo:path for github clone & source plugin from framework (eg. ohmyzsh)
#       local@path for local plugin in $ZPLUGINS_DIR/
function def-plugin {
    local PLUGIN_SOURCE=${1%%@*}                            # Plugin source: github | local
    local PLUGIN_REPO=${${1#*@}%%:*}                        # Plugin repo (if source is github)
    local PLUGIN_MODULE=${${1#*@}#*:}                       # Plugin path (if source is local) or module (if source is github & repo is framework like oh-my-zsh)
    local PLUGIN_PATH=                                      # Plugin dir in ZSH_PLUGINS_DIR
    # local PLUGIN_PATH="$ZSH_PLUGINS_DIR/${PLUGIN_REPO:t}"   # Plugin dir in ZSH_PLUGINS_DIR

    case $PLUGIN_SOURCE in
        "github") 
            PLUGIN_PATH="$ZSH_PLUGINS_DIR/${PLUGIN_REPO:t}"   # Plugin dir in ZSH_PLUGINS_DIR
            #  Clone git repository if didn't yet
            [[ ! -d $PLUGIN_PATH ]] && git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$PLUGIN_REPO $PLUGIN_PATH

            # Append module path to repo path if doesn't match
            [[ "$PLUGIN_REPO" != "$PLUGIN_MODULE" ]] && PLUGIN_PATH="$PLUGIN_PATH/$PLUGIN_MODULE"
            ;;
        "local")
            PLUGIN_PATH="$ZSH_LOCAL_PLUGINS_DIR/${PLUGIN_MODULE:t}"   # Plugin dir in ZSH_PLUGINS_DIR
            ;;
        *) exit ;;
    esac

    local PLUGIN_ENTRY=
    if [[ "$PLUGIN_PATH" == *".zsh" ]]; then
        PLUGIN_ENTRY=$PLUGIN_PATH
    else
        PLUGIN_ENTRY="$PLUGIN_PATH/${PLUGIN_MODULE:t}.plugin.zsh"
    fi


    if [[ ! -e $PLUGIN_ENTRY ]]; then
        local ENTRY_CANDIDATES=($PLUGIN_PATH/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
        (( $#ENTRY_CANDIDATES )) || { echo >&2 "No init file '$repo'." && continue }
        ln -sf $ENTRY_CANDIDATES[1] $PLUGIN_ENTRY
    fi

   source $PLUGIN_ENTRY
}

function load-plugins {
    for plugin in $@; do
        def-plugin $plugin
    done
}

