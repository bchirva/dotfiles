source "${XDG_CONFIG_HOME}"/shell/theme.sh

export VIRTUAL_ENV_DISABLE_PROMPT=1

prompt_info() {  
    local -r LAST_CMD_EXIT=$?
    
    local -r SEP="󰄾"
    local PROMPT_STR=""

    local -r ACTIVE_SHELL="${1:-bash}"
    case "${ACTIVE_SHELL}" in 
        bash) 
            declare -A ANSI_COLORS=(
                [black]='\e[0;30m'
                [red]='\e[0;31m'
                [green]='\e[0;32m'
                [yellow]='\e[0;33m'
                [blue]='\e[0;34m'
                [magenta]='\e[0;35m'
                [cyan]='\e[0;36m'
                [white]='\e[0;37m'
                )
            
            local -r FG_PRIMARY=${ANSI_COLORS[${PRIMARY_COLOR_NAME}]}
            local -r FG_SECONDARY=${ANSI_COLORS[${SECONDARY_COLOR_NAME}]}
            local -r FG_WARNING=${ANSI_COLORS[${WARNING_COLOR_NAME}]}
            local -r FG_RESET='\e[m'

            local -r DIR_FORMAT="\w"
            local -r HOST_FORMAT="\h"
            local -r USER_FORMAT="\u"
            ;;
        zsh)
            local -r FG_PRIMARY="%F{${PRIMARY_COLOR_NAME}}"
            local -r FG_SECONDARY="%F{${SECONDARY_COLOR_NAME}}"
            local -r FG_WARNING="%F{${WARNING_COLOR_NAME}}"
            local -r FG_RESET="%f"

            local -r DIR_FORMAT="%~"
            local -r HOST_FORMAT="%m"
            local -r USER_FORMAT="%n"
            ;;
        *) exit 1 ;;
    esac 

    #~~~ New line ~~~#

    PROMPT_STR+=$'\n'

    #~~~ System logo ~~~#

    PROMPT_STR+="${FG_PRIMARY}"
    case "$( awk -F '=' '/^ID=/{print $2}' /etc/os-release )" in
        arch)   PROMPT_STR+=" " ;;
        debian) PROMPT_STR+=" " ;;
        ubuntu) PROMPT_STR+=" " ;;
        *)      PROMPT_STR+=" "
    esac 
    PROMPT_STR+="${FG_RESET} "

    #~~~ User info ~~~#

    if (( UID != 1000 )); then 
        if (( UUID == 0 )); then 
            PROMPT+="${FG_WARNING}"
        else 
            PROMPT+="${FG_SECONDARY}"
        fi
        PROMPT+=" ${USER_FORMAT} ${SEP}${FG_RESET} "
    fi 

    #~~~ Hostname on SSH connenction ~~~#

    if [ -n "${SSH_CONNECTION}" ]; then 
        PROMPT_STR+="${FG_WARNING}󰖟 ${HOST_FORMAT} ${SEP}${FG_RESET} "
    fi 

    #~~~ Virtual environment ~~~#

    if [ -n "${VIRTUAL_ENV}" ]; then 
        PROMPT_STR+="${FG_SECONDARY} $(basename "${VIRTUAL_ENV}") ($(python3 --version | awk '{print $NF}')) ${SEP}${FG_RESET} "
    fi

    #~~~ Readonly marker ~~~#

    if [ -d . ] && [ ! -w . ]; then 
        local -r READONLY_MARKER="${FG_WARNING} 󰉐 ${FG_RESET}"
    fi

    #~~~ Git repository or PWD info ~~~#

    PROMPT_STR+="${FG_PRIMARY}"
    if [[ $(git status 2>/dev/null; echo $?) != 128 ]]; then
        local GIT_PATH="" GIT_INFO=""

        GIT_PATH="$(basename "$(git rev-parse --show-toplevel)")"

        local -r repo_path=$(git rev-parse --show-prefix | sed 's:/$::')
        if [ -n "${repo_path}" ]; then 
            GIT_PATH+="/${repo_path}"
        fi
        
        local -r git_head="$(git status --branch 2>/dev/null | head -n 1 | awk '{print $NF}')"
        GIT_INFO=" ${FG_SECONDARY}${SEP}  ${git_head}"

        local -r git_tag=$(git tag --points-at 2>/dev/null)
        if [[ -n "${git_tag}" ]]; then 
            if [[ "${git_tag}" != "${git_head}" ]]; then 
                GIT_INFO+="$(echo "${git_tag}" | xargs -n1 printf '  %s')"
            else 
                GIT_INFO+=" "
            fi
        fi

        if [[ -n "$(git status --short 2>/dev/null)" ]]; then 
            GIT_INFO+=" ${FG_WARNING}(~)"
        fi
        GIT_INFO+="${FG_RESET}"

        PROMPT_STR+="${GIT_PATH}${READONLY_MARKER}${GIT_INFO}"
    else 
        PROMPT_STR+="${DIR_FORMAT}${READONLY_MARKER}"
    fi
    PROMPT_STR+="${FG_RESET}"

    #~~~ Last command exit status ~~~#

    if (( LAST_CMD_EXIT == 0 || LAST_CMD_EXIT == 130 )); then 
        PROMPT_STR+=" ${FG_PRIMARY}"
    else 
        PROMPT_STR+=" ${FG_WARNING}!"
    fi
    PROMPT_STR+="${SEP}${FG_RESET} "
    
    printf '%s' "${PROMPT_STR}"
}

