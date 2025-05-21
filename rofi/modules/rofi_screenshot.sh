#!/bin/bash

source $HOME/.config/theme.sh

rofi_input() {
    echo -en "$(colored-icon pango 󰹑 ) ...selected area or window\n"
    echo -en "$(colored-icon pango 󰹑 ) ...focused window in 3 sec\n"
}

variant=$(rofi_input | rofi -config "~/.config/rofi/modules/controls_config.rasi" \
    -markup-rows -i -dmenu -p "Screenshot of..." -format "i" -l 2 -no-custom)

if [[ $variant ]]; then
    case $variant in
        0) screenshot-cmd select ;;
        1) screenshot-cmd focused ;;
        *) exit ;;
    esac
fi

