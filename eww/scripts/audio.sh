#!/usr/bin/env bash

function main() {
    local -r operation=$1
    local -r device_type=$2

    case $operation in
        "mute") audio-ctrl set "${device_type}" -m;;
        "level") audio-ctrl set "${device_type}" -v "$3";;
        "status") audio-ctrl info "${device_type}" ;;
        "list") audio-ctrl list "${device_type}" ;;
        "choose") ~/.config/rofi/modules/rofi_audio.sh "${device_type}" ;;
    esac
}

main "$@"
