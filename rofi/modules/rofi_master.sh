#!/usr/bin/env bash

source ${XDG_CONFIG_HOME}/theme.sh

function main() {
    function rofi_entries() {
        echo -en "$(colored-icon pango  ) Sound output\n"
        echo -en "$(colored-icon pango  ) Sound input\n"
        echo -en "$(colored-icon pango 󰖟 ) Network\n"
        echo -en "$(colored-icon pango 󰂯 ) Bluetooth\n"
        echo -en "$(colored-icon pango  ) System monitor\n"
        echo -en "$(colored-icon pango  "${WARNING_COLOR}") Colorschemes picker\n"
        echo -en "$(colored-icon pango  "${WARNING_COLOR}") Password manager\n"
        echo -en "$(colored-icon pango  "${ERROR_COLOR}") Logout\n"
    }

    local -r variant=$(rofi_entries \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "Control Center" \
        -l 8)

    case $variant in 
        0) rofi-audio-ctrl output ;;
        1) rofi-audio-ctrl input ;;
        2) rofi-network-ctrl main;;
        3) rofi-bluetooth-ctr main;;
        4) kitty -e btm ;;
        5) rofi-colorschemes ;;
        6) rofi-passwords ;;
        7) rofi-powermenu ;;
        *) exit ;;
    esac
}

main "$@"
