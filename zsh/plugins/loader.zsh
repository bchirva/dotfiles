#!/bin/zsh 

# Directory where anplugz downloads plugins from remote repositories (e.g., GitHub)
: ${ZSH_PLUGINS_DIR:=$HOME/.local/share/zsh/plugins}
# Directory where anplugz searches for locally stored plugins (default: $ZDOTDIR/plugins)
: ${ZSH_LOCAL_PLUGINS_DIR:=$ZDOTDIR/plugins}
# Enable debug info (loading time)
: ${ZSH_LOADING_DEBUG:=false}

# Create directory if don't exist
if [[ ! -d $ZSH_PLUGINS_DIR ]]; then
    mkdir --parents $ZSH_PLUGINS_DIR
fi

# Define plugin. Argument is [repository:]path
# Plugin definition format examples:
#       github.com/user/repo for github clone
function def-plugin {
    local PLUGIN_REPO=${1}  # Plugin repo (if source is github)
    local PLUGIN_PATH=      # Plugin dir in ZSH_PLUGINS_DIR
    local PLUGIN_NAME=${PLUGIN_REPO:t}

    local RESET='\033[0m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local CLEAR='\r\033[0K'

    PLUGIN_PATH="$ZSH_PLUGINS_DIR/${PLUGIN_NAME}"   # Plugin dir in ZSH_PLUGINS_DIR
    #  Clone git repository if didn't yet
    if [[ ! -d $PLUGIN_PATH ]]; then
        echo -en "$YELLOW○$RESET Downloading plugin $PLUGIN_REPO from GitHub..."
        echo -e "$CLEAR$GREEN●$RESET Plugin $PLUGIN_REPO has been successfully loaded from GitHub!"
    fi

    local PLUGIN_ENTRY=
    PLUGIN_ENTRY="$PLUGIN_PATH/${PLUGIN_NAME}.plugin.zsh"

    if [[ ! -e $PLUGIN_ENTRY ]]; then
        local ENTRY_CANDIDATES=($PLUGIN_PATH/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
        (( $#ENTRY_CANDIDATES )) || { echo >&2 "No init file '$repo'." && continue }
        ln -sf $ENTRY_CANDIDATES[1] $PLUGIN_ENTRY
    fi

   source $PLUGIN_ENTRY

   [[ $ZSH_LOADING_DEBUG == true ]] && echo -e "$GREEN√$RESET Plugin $PLUGIN_ENTRY is loaded!"
}

function load-plugins {
    local START=$(date +"%s.%6N")

    for plugin in $@; do
        def-plugin $plugin
    done

    if [[ ${ZSH_LOADING_DEBUG} == true ]]; then
        local END=$(date +"%s.%6N")
        local ELAPSED=$(printf "%.3f" "$END - $START")
        echo "Total loading time: $ELAPSED seconds"
    fi
}

