#!/bin/bash

power_options="\
Shutdown\0icon\x1fsystem-shutdown-symbolic\n\
Reboot\0icon\x1fsystem-reboot-symbolic\n\
Lock\0icon\x1fsystem-lock-screen-symbolic\n\
Logout\0icon\x1fsystem-log-out-symbolic\n"

variant=$(echo -en $power_options | rofi -config "~/.config/rofi/modules/controls_config.rasi"\
    -i -dmenu -p "System:" -no-custom -l 4 -format 'i' )

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
