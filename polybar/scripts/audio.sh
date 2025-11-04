#!/usr/bin/env sh

main() {
    operation=$1
    channel=$2

    case $operation in
        status)
            active_status_json=$(audio-ctrl info "${channel}")
            muted=$(printf '%s\n' "${active_status_json}" \
                | jq -r ".muted" )
       
            if ${muted} ; then
                case $channel in
                    output) printf '%s\n' "" ;;
                    input) printf '%s\n' "󰍭" ;;
                esac
            else
                case $channel in
                    output) printf '%s\n' "" ;;
                    input) printf '%s\n' "󰍬" ;;
                esac
            fi
        ;;
        menu) rofi-audio-ctrl "${channel}" ;;
        *) exit 2 ;;
    esac
}

main "$@"
