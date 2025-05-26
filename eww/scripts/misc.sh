#!/usr/bin/env bash

function main () {
    case $1 in
        "powermenu") ~/.config/rofi/modules/rofi_powermenu.sh ;;
        "colorschemes") ~/.config/rofi/modules/rofi_colorscheme.sh ;;
        "system-monitor") kitty -e btm ;;
        "edit-configs" ) kitty -e nvim ~/.config/ ;;
        "launcher" ) rofi -show drun ;;
        "control_center" ) eww open --toggle control_center --arg monitor_name="$2" ;;
        "status_monitor" ) eww open --toggle status_monitor --arg monitor_name="$2" ;;
        "menu") ~/.config/rofi/modules/rofi_master.sh ;;
        *) exit 2 ;;
    esac
}

main "$@"
