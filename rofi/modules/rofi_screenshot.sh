#!/bin/bash

source $HOME/.config/rofi/modules/rofi_icon.sh
source $HOME/.config/rofi/modules/utils_scripts/screenshot_helper.sh

rofi_input() {
    echo -en "$(pango_markup 󰹑 ) ...selected area or window\n"
    echo -en "$(pango_markup 󰹑 ) ...focused window in 3 sec\n"
}

variant=$(rofi_input | rofi -config "~/.config/rofi/modules/controls_config.rasi" \
    -markup-rows -i -dmenu -p "Screenshot of..." -format "i" -l 2 -no-custom)

if [[ $variant ]]; then
    case $variant in
        0) screenshot_select ;;
        1) screenshot_focused ;;
        *) exit ;;
    esac
fi

