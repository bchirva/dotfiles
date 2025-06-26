#!/usr/bin/env bash

source ${XDG_CONFIG_HOME}/theme.sh

function main() {
    local -r colorschemes_dir="$(readlink -f \
        "$(dirname \
        "$(readlink -f $HOME/Documents/dotfiles/colorschemes/build)")/..")/colorschemes/build/"

    readarray -t schemes <<< "$(ls -1 "${colorschemes_dir}" \
        | sed -e 's/\///g' -e '/active/d')"

    function rofi_input(){
        for i in ${!schemes[*]} 
        do
            echo -en "$(colored-icon pango  ) ${schemes[$i]}\n"
        done
    }

    local -r active_scheme=$(ls -l "${colorschemes_dir}/active" | awk '{print $NF}')
    for i in ${!schemes[*]}
    do
        if [[ "${schemes[$i]}" == "${active_scheme}" ]]; then
            local -r row_modifiers=(-a "${i}" -selected-row "${i}")
        fi
    done

    local -r variant=$(rofi_input \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/config-system.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format "i" \
        -p "Colorshemes:" \
        "${row_modifiers[@]}" \
        -l ${#schemes[@]} )

    if [[ $variant ]]; then
        local -r new_scheme=${schemes[$variant]}

        rm "${colorschemes_dir}/active"
        ln -srf "${colorschemes_dir}/${new_scheme}" "${colorschemes_dir}/active"

        local -r processes=(eww polybar dunst)

        for process in "${processes[@]}"; do 
            if pgrep "${process}"; then 
                killall "${process}"
            fi 
        done 

        if pgrep openbox > /dev/null; then 
            openbox --restart
        fi
        if pgrep bspwm > /dev/null ; then
            bspc wm -r
        fi
    fi
}

main "$@"
