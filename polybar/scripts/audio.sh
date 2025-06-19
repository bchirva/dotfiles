#!/usr/bin/env bash

function main () {
    local -r operation=$1
    local -r channel=$2

    case $operation in
        "status")
            local -r active_status_json=$(audio-ctrl info "${channel}")
            local -r muted=$(jq -r ".muted" <<< "${active_status_json}")
       
            if ${muted} ; then
                case $channel in
                    "output") echo "" ;;
                    "input") echo "󰍭" ;;
                esac
            else
                case $channel in
                    "output") echo "" ;;
                    "input") echo "󰍬" ;;
                esac
            fi
        ;;
        "menu") rofi-audio-ctrl "${channel}" ;;
        *) exit 2 ;;
    esac
}

main "$@"
