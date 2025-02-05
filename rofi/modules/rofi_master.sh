#!/bin/bash

function rofi_entries() {
    echo -en "Sound output\0icon\x1faudio-volume-high\n"
    echo -en "Sound input\0icon\x1fmic-volume-high\n"
    echo -en "Network\0icon\x1fnetwork-connect\n"
    echo -en "Bluetooth\0icon\x1fbluetooth-online\n"
    echo -en "Screenshot\0icon\x1faccessories-screenshot\n"
    echo -en "System monitor\0icon\x1futilities-system-monitor\n"
    echo -en "Logout\0icon\x1fsystem-shutdown\n"
}

variant=$(rofi_entries | rofi -config "~/.config/rofi/modules/controls_config.rasi" -i -dmenu -no-custom -format 'i' -p "Control Center" -l 7)
case $variant in 
    0) $HOME/.config/rofi/modules/rofi_audio.sh output ;;
    1) $HOME/.config/rofi/modules/rofi_audio.sh input ;;
    2) $HOME/.config/rofi/modules/rofi_network.sh ;;
    3) $HOME/.config/rofi/modules/rofi_bluetooth.sh ;;
    4) $HOME/.config/rofi/modules/rofi_screenshot.sh ;;
    5) alacritty -e btm ;;
    6) $HOME/.config/rofi/modules/rofi_powermenu.sh ;;
esac

