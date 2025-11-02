#!/usr/bin/env sh

. "${XDG_CONFIG_HOME}/shell/theme.sh"

main() {
    rofi_input() {
        printf '%s\n' "$(colored-icon pango  "${WARNING_COLOR}") Shutdown"
        printf '%s\n' "$(colored-icon pango 󰑓 "${WARNING_COLOR}") Reboot"
        printf '%s\n' "$(colored-icon pango  ) Lock"
        printf '%s\n' "$(colored-icon pango 󰍃 ) Logout"
    }

    variant=$(rofi_input \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p " System:" \
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
