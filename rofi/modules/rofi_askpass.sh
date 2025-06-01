#!/usr/bin/env bash

function main() {
    local -r input="$1"
    rofi -config "${HOME}/.config/rofi/modules/input_config.rasi" \
        -dmenu -password \
        -p " " \
        -mesg "<span>${input}</span>"
}

main "$@"
