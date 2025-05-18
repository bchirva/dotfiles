#!/bin/bash

source $HOME/.config/rofi/modules/rofi_icon.sh

power_options="\
$(pango_icon  ${ERROR_COLOR}) Shutdown\n\
$(pango_icon 󰑓 ${WARNING_COLOR}) Reboot\n\
$(pango_icon  ) Lock\n\
$(pango_icon 󰍃 ) Logout\n"

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
