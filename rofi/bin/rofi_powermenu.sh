#!/usr/bin/env bash

source ${XDG_CONFIG_HOME}/theme.sh

function main() {
    local -r power_options="\
$(colored-icon pango  "${ERROR_COLOR}") Shutdown\n\
$(colored-icon pango 󰑓 "${WARNING_COLOR}") Reboot\n\
$(colored-icon pango  ) Lock\n\
$(colored-icon pango 󰍃 ) Logout\n"

    local -r variant=$(echo -en "${power_options}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/config-system.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "System:" \
        -l 4 )

    case $variant in
        0) systemctl poweroff ;;
        1) systemctl reboot ;;
        2) loginctl lock-session "${XDG_SESSION_ID}" ;;
        3)
            if pgrep openbox > /dev/null ; then
                openbox --exit
            fi
            if pgrep bspwm > /dev/null ; then
                bspc quit
            fi
    esac
}

main "$@"
