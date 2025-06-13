#!/usr/bin/env bash

set -e 

function print_help(){
    echo "Usage: bootstrap.sh [OPTIONS]"
    echo "Options:"
    echo "  -a, --all              Symlink all dotfiles"
    echo "  -s, --select <list>    Symlink specific configs (comma-separated: one,two,three)"
    echo "  -t, --theme <name>     Symlink a colorscheme (default: onedark)"
    echo "  -h, --help             Show this help message"
}

function link_config(){
    local -r config_name="$1"

    if [[ -d "${PWD}/${config_name}" ]]; then 
        if [ -L "${CONFIG_DIR}/${config_name}" ]; then 
            rm "${CONFIG_DIR}/${config_name}"
        fi 

        if [ -d "${CONFIG_DIR}/${config_name}" ]; then 
            mv "${CONFIG_DIR}/${config_name}" "${CONFIG_DIR}/${config_name}.backup"
        fi 

        ln -sf "${PWD}/${config_name}" "${CONFIG_DIR}/${config_name}"
    fi
}

function main() {
    local SELECTED_THEME
    while (( $# > 0 )); do
        case "$1" in 
            -a|--all) 
                local -r INSTALL_ALL=true 
                shift 
            ;;
            -b|--bin)
                local -r INSTALL_BIN=true 
                shift 
            ;;
            -d|--desktop)
                local -r INSTALL_DESKTOP=true
                shift 
            ;;
            -s|--select)
                IFS=',' read -ra SELECTED_CONFIGS <<< "$2"
                shift 2
            ;;
            -t|--theme)
                SELECTED_THEME="$2"
                shift 2
            ;;
            -h|--help)
                print_help
                exit
            ;;
            *)
                echo "Wrong argument $1, abort"
                print_help
                exit 2
            ;;
        esac 
    done 
    SELECTED_THEME="${SELECTED_THEME:-onedark}"

    local -r CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"
    local -r CONFIGS=(
        bottom
        bspwm
        dunst
        eww
        fzf
        git
        gtk
        kitty
        lazydocker
        lazygit
        nvim
        picom
        polybar
        rofi
        sxhkd
        tmux
        yazi
        zathura
        zsh
    )

    local -r DOTDIRS=(
        "${HOME}/.cache/zsh/"
        "${HOME}/.config"
        "${HOME}/.fonts"
        "${HOME}/.icons"
        "${HOME}/.local/bin"
        "${HOME}/.themes"
    )
    for dotdir in "${DOTDIRS[@]}"; do 
        if [ ! -d "${dotdir}" ]; then 
            mkdir -p "${dotdir}"
        fi
    done

    if [[ "${INSTALL_ALL}" == "true" ]]; then
        local -r LINK_CONFIGS=("${CONFIGS[@]}")
    else
        local -r LINK_CONFIGS=("${SELECTED_CONFIGS[@]}")
    fi
    for config in "${LINK_CONFIGS[@]}"; do
        link_config "${config}"
    done

    if [[ "${INSTALL_BIN}" == true ]] || [[ "${INSTALL_ALL}" == "true" ]]; then 
        ln -sf "${PWD}"/bin/* "${HOME}"/.local/bin/
    fi 

    if [[ "${INSTALL_DESKTOP}" == true ]] || [[ "${INSTALL_ALL}" == "true" ]]; then 
        ln -sf "${PWD}"/xprofile        "${HOME}"/.xprofile  

        if [ -L "${HOME}/.themes/Adaptish" ]; then 
            rm "${HOME}/.themes/Adaptish"
        fi 
        ln -sf "${PWD}"/themes/Adaptish "${HOME}"/.themes/Adaptish
    fi 

    if [ ! -d "${PWD}/colorschemes/build/${SELECTED_THEME}" ]; then 
        python3 ./colorschemes/build_colorscheme.py -s "${SELECTED_THEME}"
    fi 

    if [ -L "${PWD}/colorschemes/build/active" ]; then 
        rm "${PWD}/colorschemes/build/active"
    fi 
    ln -sf "${PWD}/colorschemes/build/${SELECTED_THEME}" "${PWD}/colorschemes/build/active"
}

main "$@"
