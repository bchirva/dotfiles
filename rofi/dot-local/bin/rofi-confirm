#!/usr/bin/env sh

main() {
    CONFIRM_STR="$1"
    MESSAGE="$2"

    set -- \
        -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format i \
        -p " Confirm:" \
        -l 2

    if [ -n "$MESSAGE" ]; then
        set -- "$@" -mesg "$MESSAGE"
    fi

    case $(printf '%s\n%s\n' "$(colored-pango-icon 󰜺 ) Cancel" "$CONFIRM_STR" | rofi "$@") in 
        1) return 0 ;;
        *) return 1 ;;
    esac 
}

main "$@"
