#!/usr/bin/env bash

function main() {
    local device_type=$1

    local rofi_input="" message=""

    case $device_type in
        output|sink)   
            device_type="sink"
            local -r device_icon=""
            local -r volume_up_icon="$(colored-pango-icon 󰝝 )"
            local -r volume_down_icon="$(colored-pango-icon 󰝞 )"
            local -r mute_icon="$(colored-pango-icon 󰝟 )"
            ;;
        input|source)    
            device_type="source"
            local -r device_icon=""
            local -r volume_up_icon="$(colored-pango-icon 󰢴 )"
            local -r volume_down_icon="$(colored-pango-icon 󰢳 )"
            local -r mute_icon="$(colored-pango-icon  )"
            ;;
        *) exit 2 ;;
    esac

    rofi_input+="$volume_up_icon Volume +10%\n"
    rofi_input+="$volume_down_icon Volume -10%\n"

    local -r device_id_list="$(pactl list short "${device_type}s" \
        | cut -f 2 \
        | grep -v "\.monitor$")"
    local -r active_device_id="$(pactl "get-default-$device_type")"

    local -r active_device_mute="$(pactl "get-${device_type}-mute" "$active_device_id" \
        | sed "s/^[^ ]* // ; s/yes/true/ ; s/no/false/")"
    local -r active_device_volume="$(pactl "get-${device_type}-volume" "$active_device_id" \
        | grep -o "[0-9]*%" \
        | head -n 1)"

    if $active_device_mute; then 
        rofi_input+="$mute_icon Unmute\n"
        message+=" <i>(muted)</i>"
    else 
        rofi_input+="$mute_icon Mute\n"
    fi 

    local device_name=""
    while read -r line; do 
        device_name="$(pactl list "${device_type}s" \
            | grep -A 1 "${line}$" \
            | sed -n "2{s/^.*: //; p}")"
        rofi_input+="$(colored-pango-icon $device_icon) $device_name\n"

        if [ "$line" = "$active_device_id" ]; then 
            message="<b>$device_name</b> volume: $active_device_volume ${message}"
        fi 
    done <<< "$device_id_list"

    local -r active_device_idx="$(grep -n "$active_device_id" <<< "$device_id_list" \
        | cut -d ':' -f 1)"
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
        -l $(($(wc -l <<< "$device_id_list") + 3)) )

    if [ -n "$variant" ]; then
        case $variant in
            0) pactl "set-${device_type}-volume" "$active_device_id" "+10%" ; $0 "$1" 0 ;;
            1) pactl "set-${device_type}-volume" "$active_device_id" "-10%" ; $0 "$1" 1 ;;
            2) pactl "set-${device_type}-mute"   "$active_device_id" toggle ;;
            *) 
                local -r selected_device_id="$(sed -n "$((variant - 2))p" <<< "$device_id_list")"

                local channel=""
                case "$device_type" in
                    sink)   channel="sink-input" ;;
                    source) channel="source-output" ;;
                    *) exit 2
                esac

                pactl "set-default-${device_type}" "$selected_device_id"
                while read -r line; do 
                    pactl "move-${channel}" "$line" "$selected_device_id"
                done <<< "$(pactl list "${channel}s" short | cut -f 1)"
        esac
    fi
}

main "$@"
