#!/bin/bash

source $HOME/.config/rofi/modules/rofi_icon.sh

function rofi_entries() {
    echo -en "$(pango_icon  ) Sound output\n"
    echo -en "$(pango_icon  ) Sound input\n"
    echo -en "$(pango_icon 󰖟 ) Network\n"
    echo -en "$(pango_icon 󰂯 ) Bluetooth\n"
    echo -en "$(pango_icon  ) System monitor\n"
    echo -en "$(pango_icon  ${ERROR_COLOR}) Logout\n"
}

variant=$(rofi_entries | rofi -config "~/.config/rofi/modules/controls_config.rasi" -markup-rows -i -dmenu -no-custom -format 'i' -p "Control Center" -l 6)
case $variant in 
    0) $HOME/.config/rofi/modules/rofi_audio.sh output ;;
    1) $HOME/.config/rofi/modules/rofi_audio.sh input ;;
    2) $HOME/.config/rofi/modules/rofi_network.sh main;;
    3) $HOME/.config/rofi/modules/rofi_bluetooth.sh main;;
    4) kitty -e btm ;;
    5) $HOME/.config/rofi/modules/rofi_powermenu.sh ;;
    *) exit ;;
esac

