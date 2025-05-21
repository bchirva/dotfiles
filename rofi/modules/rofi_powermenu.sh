#!/bin/bash

source $HOME/.config/theme.sh

power_options="\
$(colored-icon pango  ${ERROR_COLOR}) Shutdown\n\
$(colored-icon pango 󰑓 ${WARNING_COLOR}) Reboot\n\
$(colored-icon pango  ) Lock\n\
$(colored-icon pango 󰍃 ) Logout\n"

variant=$(echo -en $power_options | rofi -config "~/.config/rofi/modules/controls_config.rasi"\
    -markup-rows -i -dmenu -p "System:" -no-custom -l 4 -format 'i' )

case $variant in
    0) systemctl poweroff ;;
    1) systemctl reboot ;;
    2) loginctl lock-session ${XDG_SESSION_ID} ;;
    3)
        if pgrep openbox > /dev/null ; then
            openbox --exit
        fi
        if pgrep bspwm > /dev/null ; then
            bspc quit
        fi
esac
