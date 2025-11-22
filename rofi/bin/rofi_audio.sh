#!/usr/bin/env bash

function main() {
    local -r device_type=$1

    local rofi_input="" message=""

    case $device_type in
        "output")   
            local -r device_icon=""
            local -r volume_up_icon="$(colored-pango-icon 󰝝 )"
            local -r volume_down_icon="$(colored-pango-icon 󰝞 )"
            local -r mute_icon="$(colored-pango-icon 󰝟 )"
            ;;
        "input")    
            local -r device_icon=""
            local -r volume_up_icon="$(colored-pango-icon 󰢴 )"
            local -r volume_down_icon="$(colored-pango-icon 󰢳 )"
            local -r mute_icon="$(colored-pango-icon  )"
            ;;
        *) exit 2 ;;
    esac

    rofi_input+="$volume_up_icon Volume +10%\n"
    rofi_input+="$volume_down_icon Volume -10%\n"

    local -r device_list="$(audio-ctrl list "$device_type")"
    local -r active_device="$(grep "$(audio-ctrl id "$device_type")" <<< "$device_list")"

    message="<b>$(cut -f 2 <<< "$active_device")</b> volume: $(cut -f 3 <<< "$active_device")%"
    if "$(cut -f 4 <<< "$active_device")"; then 
        rofi_input+="$mute_icon Unmute\n"
        message+=" <i>(muted)</i>"
    else 
        rofi_input+="$mute_icon Mute\n"
    fi 

    while read -r line; do 
        rofi_input+="$(colored-pango-icon $device_icon) $(cut -f 2 <<< "$line")\n"
    done <<< "$device_list"

    local -r active_device_idx="$(grep -n "$active_device" <<< "$device_list" | cut -d ':' -f 1)"
    local row_modifiers=(-a $((active_device_idx + 2)))
    if [ -n "$2" ]; then
        row_modifiers+=(-selected-row "$2")
    else
        row_modifiers+=(-selected-row $((active_device_idx + 2)))
    fi

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "$device_icon Audio:" \
        -mesg "$message" \
        "${row_modifiers[@]}" \
        -l $(($(wc -l <<< "$device_list") + 3)) )

    if [ -n "$variant" ]; then
        case $variant in
            0) audio-ctrl volume "$device_type" "+10"   ; $0 "$1" 0 ;;
            1) audio-ctrl volume "$device_type" "-10"   ; $0 "$1" 1 ;;
            2) audio-ctrl mute   "$device_type"         ; $0 "$1" 2 ;;
            *) audio-ctrl choose "$device_type" "$(sed -n "$((variant - 2)){s/\s.*$// ;p}" <<< "$device_list")" ;;
        esac
    fi
}

main "$@"
