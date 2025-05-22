#!/usr/bin/env bash

function main() {
    local -r operation=$1

    case $operation in
        "status")
            if [[ "$(network-ctrl system status)" == "true" ]]; then
                local -r active_device=$(network-ctrl device list \
                    | jq ".[] | select(.device == $(network-ctrl connection list \
                    | jq ".[0].device"))")

                if [[ "${active_device}" ]]; then 
                    jq -n "{ \
                        enabled: true, \
                        connection: { \
                            type: $(jq ".type" <<< "${active_device}"), \
                            name: $(jq ".device" <<< "${active_device}") \
                        }}"
                else 
                    jq -n "{ \
                        enabled: true, \
                        connection: null \
                    }"
                fi
            else 
                jq -n "{ enabled: false }"
            fi
            ;;
        "toggle")
            local -r toggle_flag=$(network-ctrl system status \
                | sed -e "s/true/off/g" -e "s/false/on/g")
                network-ctrl system toggle "${toggle_flag}" 
            ;;
        "menu") ~/.config/rofi/modules/rofi_network.sh main ;;
    esac
}

main "$@"
