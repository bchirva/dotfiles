#!/usr/bin/env sh

main() {
    operation=$1
    channel=$2

    case $operation in
        status)
            active_status=$(audio-ctrl list "$channel" \
                | grep "$(audio-ctrl id "$channel")")
            muted=$(printf '%s\n' "${active_status}" \
                | cut -f 4)
       
            if ${muted} ; then
                case $channel in
                    output) printf '%s\n' "󰝟" ;;
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
