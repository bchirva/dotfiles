source "${XDG_CONFIG_HOME}"/shell/theme.sh

export VIRTUAL_ENV_DISABLE_PROMPT=1

prompt_info() {  
    local -r LAST_CMD_EXIT=$?

    local LOGO VENV_INFO DIR GIT_INFO LAST_CMD

    local -r shell="${1:-bash}"

    case "${shell}" in 
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

            local -r DIR_FORMAT="\W"
            ;;
        zsh)
            local -r FG_PRIMARY="%F{${PRIMARY_COLOR_NAME}}"
            local -r FG_SECONDARY="%F{${SECONDARY_COLOR_NAME}}"
            local -r FG_WARNING="%F{${WARNING_COLOR_NAME}}"
            local -r FG_RESET="%f"
            local -r DIR_FORMAT="%~"
            ;;
        *) exit 1 ;;
    esac 

    local -r SEP="󰄾"

    # System logo
    LOGO="${FG_PRIMARY}"
    case "$( awk -F '=' '/^ID=/{print $2}' /etc/os-release )" in
        arch)   LOGO+=" " ;;
        debian) LOGO+=" " ;;
        ubuntu) LOGO+=" " ;;
        *)      LOGO+=" "
    esac 
    LOGO+="${FG_RESET} "

    # if (( UID != 1000 )); then 
    #     USER_INFO="${USER} ${SEP}"
    # fi 
    
    if [ -n "${VIRTUAL_ENV}" ]; then 
        VENV_INFO="${FG_SECONDARY} $(basename "${VIRTUAL_ENV}") ($(python3 --version | awk '{print $NF}')) ${SEP}${FG_RESET} "
    fi

    # Git info
    if [[ $(git status 2>/dev/null; echo $?) != 128 ]]; then
        GIT_PATH="$(basename "$(git rev-parse --show-toplevel)")"

        local -r repo_path=$(git rev-parse --show-prefix | sed 's:/$::')
        if [ -n "${repo_path}" ]; then 
            GIT_PATH+="/${repo_path}"
        fi
        
        local -r git_head="$(git status --branch 2>/dev/null | head -n 1 | awk '{print $NF}')"
        local -r git_tag=$(git tag --points-at 2>/dev/null)
        GIT_INFO=" ${SEP}  ${git_head}"
        if [[ -n "${git_tag}" ]]; then 
            if [[ "${git_tag}" != "${git_head}" ]]; then 
                GIT_INFO+="$(echo "${git_tag}" | xargs -n1 printf '  %s')"
            else 
                GIT_INFO+=" "
            fi
        fi

        GIT_INFO="${FG_SECONDARY}${GIT_INFO}${FG_RESET}"
        if [[ -n "$(git status --short 2>/dev/null)" ]]; then 
            GIT_INFO+=" ${FG_WARNING}(~)${FG_RESET}"
        fi

        DIR="${FG_PRIMARY}${GIT_PATH}${FG_RESET}"
    else 
        DIR="${FG_PRIMARY}${DIR_FORMAT}${FG_RESET}"
    fi

    if [ -d . ] && [ ! -w . ]; then 
        DIR+="${FG_WARNING} 󰉐 ${FG_RESET}"
    fi

    # Last command exit status
    if (( LAST_CMD_EXIT == 0 )); then 
        LAST_CMD=" ${FG_PRIMARY}${SEP}${FG_RESET} "
    else 
        LAST_CMD=" ${FG_WARNING}!${SEP}${FG_RESET} "
    fi
    
    printf '%s' $'\n'"${LOGO}${VENV_INFO}${DIR}${GIT_INFO}${LAST_CMD}"
}

