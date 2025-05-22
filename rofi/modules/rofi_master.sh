#!/usr/bin/env bash

source $HOME/.config/theme.sh

function main() {
    function rofi_entries() {
        echo -en "$(colored-icon pango  ) Sound output\n"
        echo -en "$(colored-icon pango  ) Sound input\n"
        echo -en "$(colored-icon pango 󰖟 ) Network\n"
        echo -en "$(colored-icon pango 󰂯 ) Bluetooth\n"
        echo -en "$(colored-icon pango  ) System monitor\n"
        echo -en "$(colored-icon pango  "${ERROR_COLOR}") Logout\n"
    }

    local -r variant=$(rofi_entries \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -no-custom -format 'i' -p "Control Center" -l 6)

    case $variant in 
        0) $HOME/.config/rofi/modules/rofi_audio.sh output ;;
        1) $HOME/.config/rofi/modules/rofi_audio.sh input ;;
        2) $HOME/.config/rofi/modules/rofi_network.sh main;;
        3) $HOME/.config/rofi/modules/rofi_bluetooth.sh main;;
        4) kitty -e btm ;;
        5) $HOME/.config/rofi/modules/rofi_powermenu.sh ;;
        *) exit ;;
    esac
}

main "$@"
