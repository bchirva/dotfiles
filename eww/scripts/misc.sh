#!/bin/bash

case $1 in
    "powermenu")    ~/.config/rofi/modules/rofi_powermenu.sh ;;
    "colorschemes") ~/.config/rofi/modules/rofi_colorscheme.sh ;;
    "system-monitor") alacritty -e btm ;;
    "edit-configs" ) alacritty -e nvim ~/.config/ ;;
    "launcher" ) rofi -show drun ;;
    "control_center" ) eww open --toggle control_center --arg monitor_name=$2;;
    "status_monitor" ) eww open --toggle status_monitor --arg monitor_name=$2;;
    *) exit ;;
esac
