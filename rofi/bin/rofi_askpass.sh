#!/usr/bin/env bash

function main() {
    local -r input="$1"
    rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-input.rasi" \
        -dmenu -password \
        -p " " \
        -mesg "<span>${input}</span>"
}

main "$@"
