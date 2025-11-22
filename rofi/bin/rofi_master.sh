#!/usr/bin/env sh

. "$XDG_CONFIG_HOME/shell/theme.sh"

main() {
    rofi_entries() {
        printf '%s\n' "$(colored-pango-icon  ) Audio output"
        printf '%s\n' "$(colored-pango-icon  ) Audio input"
        printf '%s\n' "$(colored-pango-icon 󰖟 ) Network"
        printf '%s\n' "$(colored-pango-icon 󰂯 ) Bluetooth"
        printf '%s\n' "$(colored-pango-icon  ) System monitor"
        printf '%s\n' "$(colored-pango-icon  "$ERROR_COLOR") Logout"
    }

    variant=$(rofi_entries \
        | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p " Control Center" \
        -l 6)

    case $variant in 
        0) rofi-audio-ctrl output ;;
        1) rofi-audio-ctrl input ;;
        2) rofi-network-ctrl main;;
        3) rofi-bluetooth-ctrl main;;
        4) $TERMINAL -e btm ;;
        5) rofi-powermenu ;;
        *) exit 2;;
    esac
}

main "$@"
