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
        0) ${XDG_CONFIG_HOME}/rofi/modules/rofi_audio.sh output ;;
        1) ${XDG_CONFIG_HOME}/rofi/modules/rofi_audio.sh input ;;
        2) ${XDG_CONFIG_HOME}/rofi/modules/rofi_network.sh main;;
        3) ${XDG_CONFIG_HOME}/rofi/modules/rofi_bluetooth.sh main;;
        4) kitty -e btm ;;
        5) ${XDG_CONFIG_HOME}/rofi/modules/rofi_colorscheme.sh ;;
        6) ${XDG_CONFIG_HOME}/rofi/modules/rofi_passwords.sh ;;
        7) ${XDG_CONFIG_HOME}/rofi/modules/rofi_powermenu.sh ;;
        *) exit ;;
    esac
}

main "$@"
