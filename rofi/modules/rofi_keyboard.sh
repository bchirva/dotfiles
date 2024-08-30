#!/bin/bash

readarray -t layouts <<< $(xkb-switch --list)

rofi_input(){
    for i in ${!layouts[*]}
    do
        echo -en "${layouts[$i]}\0icon\x1finput-keyboard\n"
    done
}

row_modifiers(){
    for i in ${!layouts[*]}
    do
        if [[ "${layouts[$i]}" == "$(xkb-switch -p)" ]]; then
            echo -en "-a ${i} -selected-row ${i}"
        fi
    done
}

variant=$(rofi_input | rofi -config "~/.config/rofi/modules/device_list.rasi"\
    -i -dmenu -p "Keyboard layouts:" -no-custom $(row_modifiers) -l ${#layouts[@]} | awk '{print $2}')

if [[ $variant ]]; then
    xkb-switch -s $variant
fi
