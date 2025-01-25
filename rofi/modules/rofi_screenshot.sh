#!/bin/bash

source ~/.config/rofi/modules/utils_scripts/screenshot_helper.sh

rofi_input() {
    echo -en "selected area or window\0icon\x1faccessories-screenshot\n"
    echo -en "focused window in 3 seconds\0icon\x1faccessories-screenshot\n"
}

variant=$(rofi_input | rofi -config "~/.config/rofi/modules/controls_config.rasi" \
    -i -dmenu -p "Screenshot of..." -format "i" -l 2 -no-custom)

if [[ $variant ]]; then
    case $variant in
        0) screenshot_select ;;
        1) screenshot_focused ;;
        *) exit ;;
    esac
fi

