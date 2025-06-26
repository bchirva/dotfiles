#!/usr/bin/env bash

function main() {
    local -r device_type=$1

    local rofi_input message
    case $device_type in
        "output")   
            local -r device_icon="$(colored-icon pango  )"
            local -r volume_up_icon="$(colored-icon pango 󰝝 )"
            local -r volume_down_icon="$(colored-icon pango 󰝞 )"
            local -r mute_icon="$(colored-icon pango 󰝟 )"
            ;;
        "input")    
            local -r device_icon="$(colored-icon pango )"
            local -r volume_up_icon="$(colored-icon pango 󰢴 )"
            local -r volume_down_icon="$(colored-icon pango 󰢳 )"
            local -r mute_icon="$(colored-icon pango  )"
            ;;
        *) exit 2 ;;
    esac

    rofi_input+="${volume_up_icon} Volume +10%\n"
    rofi_input+="${volume_down_icon} Volume -10%\n"

    local -r device_list_json=$(audio-ctrl list "${device_type}")
    local -r active_device_json=$(audio-ctrl info "${device_type}")

    if [[ "$(jq -r ".muted" <<< "${active_device_json}")" == "true" ]]; then 
        rofi_input+="${mute_icon} Unmute\n"
    else 
        rofi_input+="${mute_icon} Mute\n"
    fi 

    local device_id_list=()
    local active_device_idx=0
    for ((i = 0; i < $(jq ". | length" <<< "${device_list_json}"); i++))
    do
        device_id_list[${#device_id_list[@]}]=$(jq -r ".[$i].id" <<< "${device_list_json}")
        rofi_input+="${device_icon} $(jq -r ".[$i].name" <<< "${device_list_json}")\n"

        if [ "$(jq -r '.id' <<< "${active_device_json}")" == "$(jq -r ".[$i].id" <<< "${device_list_json}")" ]; then
            active_device_idx=$i
        fi
    done

    message="<b>$(jq -r ".name" <<< "${active_device_json}")</b> volume: $(jq -r ".volume" <<< "${active_device_json}")%"
    if [[ $(jq -r ".muted" <<< "${active_device_json}") == "true" ]]; then
        message+=" <i>(muted)</i>"
    fi

    local row_modifiers=(-a $((active_device_idx + 3)))
    if [[ $2 ]]; then
        row_modifiers+=(-selected-row "$2")
    else
        row_modifiers+=(-selected-row $((active_device_idx + 3)))
    fi

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/config-dmenu.rasi" \
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
