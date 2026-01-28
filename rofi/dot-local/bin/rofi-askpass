#!/usr/bin/env sh

main() {
    input="$1"
    rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-input.rasi" \
        -dmenu -password \
        -p " " \
        -mesg "<span>$input</span>"
}

main "$@"
