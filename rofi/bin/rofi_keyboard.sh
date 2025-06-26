#!/usr/bin/env bash

source ${XDG_CONFIG_HOME}/theme.sh

function main() {
    readarray -t layouts <<< "$(xkb-switch --list)"

    rofi_input(){
        for i in ${!layouts[*]}
        do
            echo -en "$(colored-icon pango  ) ${layouts[$i]}\n"
        done
    }

    for i in ${!layouts[*]}
    do
        if [[ "${layouts[$i]}" == "$(xkb-switch -p)" ]]; then
            local -r row_modifiers=(-a "${i}" -selected-row "${i}")
        fi
    done

    local -r variant=$(rofi_input \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/config-system.rasi"\
        -markup-rows -i -dmenu -no-custom \
        -format "i" \
        -p "Keyboard layouts:" \
        "${row_modifiers[@]}" \
        -l ${#layouts[@]} )

    if [[ $variant ]]; then
        xkb-switch -s "${layouts[$variant]}"
    fi
}

main "$@"
