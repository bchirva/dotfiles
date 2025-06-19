#!/usr/bin/env bash

function main() {
    local -r device_type=$1

    local rofi_input message
    case $device_type in
        "output")   
            rofi_input="$(colored-icon pango 󰝝 ) Volume +10%\n$(colored-icon pango 󰝞 ) Volume -10%\n$(colored-icon pango 󰝟 ) Mute\n"
            local -r device_icon="󱄠"
            ;;
        "input")    
            rofi_input="$(colored-icon pango 󰢴 ) Volume +10%\n$(colored-icon pango 󰢳 ) Volume -10%\n$(colored-icon pango  ) Mute\n"
            local -r device_icon=""
            ;;
        *) exit 2 ;;
    esac

    local -r device_list_json=$(audio-ctrl list "${device_type}")
    local -r active_device_json=$(audio-ctrl info "${device_type}")

    local device_id_list=()
    local active_device_idx=0
    for ((i = 0; i < $(jq ". | length" <<< "${device_list_json}"); i++))
    do
        device_id_list[${#device_id_list[@]}]=$(jq -r ".[$i].id" <<< "${device_list_json}")
        rofi_input+="$(colored-icon pango ${device_icon} ) $(jq -r ".[$i].name" <<< "${device_list_json}")\n"

        if [ "$(jq -r '.id' <<< "${active_device_json}")" == "$(jq -r ".[$i].id" <<< "${device_list_json}")" ]; then
            active_device_idx=$i
        fi
    done

    message="Active device: Volume $(jq -r ".volume" <<< "${active_device_json}")"
    if [[ $(jq -r ".muted" <<< "${active_device_json}") == "yes" ]]; then
        message="$message (muted)"
    fi

    local row_modifiers=(-a $((active_device_idx + 3)))
    if [[ $2 ]]; then
        row_modifiers+=(-selected-row "$2")
    else
        row_modifiers+=(-selected-row $((active_device_idx + 3)))
    fi

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "Audio control:" \
        -mesg "${message}" \
        "${row_modifiers[@]}" \
        -l $((${#device_id_list[@]} + 3)) )

    if [[ $variant ]]; then
        case $variant in
            0) 
                audio-ctrl set "${device_type}" -v +10
                $0 "$1" 0 
                ;;
            1) 
                audio-ctrl set "${device_type}" -v -10
                $0 "$1" 1 
                ;;
            2) 
                audio-ctrl set "${device_type}" -m
                $0 "$1" 2 
                ;;
            *) 
                audio-ctrl choose "${device_type}" "${device_id_list[$((variant - 3))]}"
            ;;
        esac
    fi
}

main "$@"
