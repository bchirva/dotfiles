#!/bin/bash

function rofi_entries() {
    echo -en "Sound output\0icon\x1faudio-volume-high\n"
    echo -en "Sound input\0icon\x1fmic-volume-high\n"
    echo -en "Network\0icon\x1fnetwork-connect\n"
    echo -en "Bluetooth\0icon\x1fbluetooth-online\n"
    echo -en "System monitor\0icon\x1fgpm-monitor\n"
    echo -en "Logout\0icon\x1fsystem-shutdown-symbolic\n"
}

variant=$(rofi_entries | rofi -config "~/.config/rofi/modules/controls_config.rasi" -i -dmenu -no-custom -format 'i' -p "Control Center" -l 6)
case $variant in 
    0) $HOME/.config/rofi/modules/rofi_audio.sh output ;;
    1) $HOME/.config/rofi/modules/rofi_audio.sh input ;;
    2) $HOME/.config/rofi/modules/rofi_network.sh main;;
    3) $HOME/.config/rofi/modules/rofi_bluetooth.sh ;;
    4) kitty -e btm ;;
    5) $HOME/.config/rofi/modules/rofi_powermenu.sh ;;
    *) exit ;;
esac

