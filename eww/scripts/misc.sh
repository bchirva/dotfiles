#!/usr/bin/env bash

function main () {
    case $1 in
        "powermenu") rofi-powermenu ;;
        "colorschemes") rofi-colorschemes ;;
        "system-monitor") kitty -e btm ;;
        "edit-configs" ) kitty -e nvim ~/.config/ ;;
        "launcher" ) rofi -show drun ;;
        "control_center" ) eww open --toggle control_center --arg monitor_name="$2" ;;
        "status_monitor" ) eww open --toggle status_monitor --arg monitor_name="$2" ;;
        "menu") rofi-master ;;
        *) exit 2 ;;
    esac
}

main "$@"
