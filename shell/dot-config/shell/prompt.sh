source "${XDG_CONFIG_HOME}"/shell/theme.sh

export VIRTUAL_ENV_DISABLE_PROMPT=1

prompt_info() {  
    local -r LAST_CMD_EXIT=$?
    local -r SEP="󰄾"
    
    local -r ACTIVE_SHELL="${1:-bash}"
    case "$ACTIVE_SHELL" in 
        bash) 
            local -r FG_ACCENT="\e[0;${ACCENT_COLOR_ANSI}m"
            local -r FG_INFO="\e[0;${INFO_COLOR_ANSI}m"
            local -r FG_ALERT="\e[0;${ERROR_COLOR_ANSI}m"
            local -r FG_RESET='\e[m'

            local -r DIR_FORMAT="\w"
            local -r HOST_FORMAT="\h"
            local -r USER_FORMAT="\u"
            ;;
        zsh)
            local -r FG_ACCENT=$'%{\e[0;'${ACCENT_COLOR_ANSI}$'m%}'
            local -r FG_INFO=$'%{\e[0;'${INFO_COLOR_ANSI}$'m%}'
            local -r FG_ALERT=$'%{\e[0;'${ERROR_COLOR_ANSI}$'m%}'
            local -r FG_RESET=$'%{\e[m%}'

            local -r DIR_FORMAT="%~"
            local -r HOST_FORMAT="%m"
            local -r USER_FORMAT="%n"
            ;;
        *) exit 1 ;;
    esac 

    #~~~ New line ~~~#

    local PROMPT_STR=""
    PROMPT_STR+=$'\n'

    #~~~ Hostname on SSH connection ~~~#

    if [ -n "$SSH_CONNECTION" ]; then 
        PROMPT_STR+="${FG_ALERT}󰖟 $HOST_FORMAT $SEP$FG_RESET "
    fi

    #~~~ In Docker container ~~~#

    if [ -e /.dockerenv ] || grep -qi "docker" /proc/1/cgroup ; then 
        CONTAINER_LABEL="$(hostname)"
        [ -n "$DEVPOD_WORKSPACE_ID" ] && CONTAINER_LABEL="$DEVPOD_WORKSPACE_ID"
        PROMPT_STR+="${FG_INFO} $CONTAINER_LABEL $SEP$FG_RESET "
    fi 

    #~~~ User info ~~~#

    if (( UID != 1000 )); then 
        if (( UID == 0 )); then 
            PROMPT_STR+="$FG_ALERT"
        else 
            PROMPT_STR+="$FG_INFO"
        fi

        PROMPT_STR+=" $USER_FORMAT $SEP$FG_RESET "
    fi 

    #~~~ Virtual environment ~~~#

    if [ -n "$VIRTUAL_ENV" ]; then 
        PROMPT_STR+="${FG_INFO} $(basename "$VIRTUAL_ENV") ($(python3 --version | awk '{print $NF}')) $SEP$FG_RESET "
    fi

    #~~~ Working directory readonly marker ~~~#

    if [ -d . ] && [ ! -w . ]; then 
        PROMPT_STR+="${FG_ALERT}󰉐 $FG_RESET"
    else 
        PROMPT_STR+="${FG_ACCENT}󰉋 $FG_RESET"
    fi

    #~~~ Git repository or PWD info ~~~#

    PROMPT_STR+="$FG_ACCENT"
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1 ; then
        local GIT_PATH="" GIT_INFO=""

        GIT_PATH="$(basename "$(git rev-parse --show-toplevel)")"

        local -r repo_path=$(git rev-parse --show-prefix | sed 's:/$::')
        if [ -n "$repo_path" ]; then 
            GIT_PATH+="/$repo_path"
        fi

        GIT_INFO=" $FG_INFO$SEP"

        local -r git_head="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)"
        if [ -n "$git_head" ]; then 
            GIT_INFO+="  $git_head"
        fi 

        local -r git_tag=$(git tag --points-at 2>/dev/null)
        if [ -n "$git_tag" ]; then 
            if [ "$git_tag" != "$git_head" ]; then 
                GIT_INFO+="$(printf '%s' "$git_tag" | xargs -n1 printf '  %s')"
            else 
                GIT_INFO+=" "
            fi
        fi

        local -r git_changes=$(git status --short 2>/dev/null | wc -l)
        if (( git_changes > 0 )) ; then 
            GIT_INFO+=" $FG_ALERT~$git_changes"
        fi
        GIT_INFO+="$FG_RESET"

        PROMPT_STR+="$GIT_PATH$GIT_INFO"
    else 
        PROMPT_STR+="$DIR_FORMAT"
    fi
    PROMPT_STR+="$FG_RESET"

    #~~~ Last command exit status ~~~#

    if (( LAST_CMD_EXIT == 0 || LAST_CMD_EXIT == 130 )); then 
        PROMPT_STR+=" $FG_ACCENT"
    else 
        PROMPT_STR+=" $FG_ALERT!"
    fi
    PROMPT_STR+="$SEP$FG_RESET "
    
    printf '%s' "$PROMPT_STR"
}
