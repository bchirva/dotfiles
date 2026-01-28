#!/usr/bin/env bash

if ! command -v bluetoothctl > /dev/null ; then 
    exit 1
fi

source "${XDG_CONFIG_HOME}/shell/theme.sh"

function main_menu {
    local -r total_status=$(bluetoothctl show \
        | sed "s/^[[:space:]]*//; s/yes/true/; s/no/false/")

    local -r powered="$(grep "^Powered:" <<< "$total_status" | cut -d ' ' -f 2)"
    local -r pairable="$(grep "^Pairable:" <<< "$total_status" | cut -d ' ' -f 2)"
    local -r discoverable="$(grep "^Discoverable:" <<< "$total_status" | cut -d ' ' -f 2)"

    local rofi_message="" rofi_input=""
    if $powered; then 
        rofi_input="${rofi_input}$(colored-pango-icon ) Power: <b>On</b>\n"
    else 
        rofi_input="${rofi_input}$(colored-pango-icon 󰅖) Power: <b>Off</b>\n"
    fi 

    if $pairable; then 
        rofi_input="${rofi_input}$(colored-pango-icon ) Pairable: <b>On</b>\n"
    else 
        rofi_input="${rofi_input}$(colored-pango-icon 󰅖) Pairable: <b>Off</b>\n"
    fi 

    if $discoverable; then 
        rofi_input="${rofi_input}$(colored-pango-icon ) Discoverable: <b>On</b>\n"
    else 
        rofi_input="${rofi_input}$(colored-pango-icon 󰅖) Discoverable: <b>Off</b>\n"
    fi 

    rofi_input+="$(colored-pango-icon 󰂳) Bluetooth devices menu\n"

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰂯 Bluetooth:" \
        -l 4 )

    if [ -z "${variant}" ]; then
        exit;
    fi
    case $variant in 
        0) 
            if $powered ; then 
               bluetoothctl power off
            else 
                if rfkill list bluetooth | grep -q "blocked: yes"; then 
                    rfkill unblock bluetooth && sleep 3
                fi 
                bluetoothctl power on
            fi
            ;;
        1) bluetoothctl pairable "$(sed "s/true/off/; s/false/on/" <<< "$pairable")" ;;
        2) bluetoothctl discoverable "$(sed "s/true/off/; s/false/on/" <<< "$discoverable")" ;;
        3) devices_menu
    esac 
}

function devices_menu() {
    local -r device_id_list=$(bluetoothctl devices \
        | grep "^Device" \
        | cut -d ' ' -f 2)

    local -r devices_count=$(wc -l <<< "$device_id_list")

    local rofi_input="" rofi_message=""

    rofi_input+="$(colored-pango-icon 󰑓 ) Scan for devices\n"

    local device_info="" device_name="" device_icon="" battery="" battery_span="" connected_devices=0
    for device_id in $device_id_list; do
        device_info=$(bluetoothctl info "$device_id" \
            | sed "s/^[[:space:]]*//; s/yes/true/; s/no/false/")

        device_name=$(grep "^Name:" <<< "$device_info" \
            | cut -d ' ' -f 2-)
        connected=$(grep "^Connected:" <<< "$device_info" \
            | cut -d ' ' -f 2)

        if $connected; then 
            device_icon="󰂱"
            
            battery="$(grep "^Battery Percentage:" <<< "$device_info" \
                | cut -d ' ' -f 4)"
            if [ -n "$battery" ]; then 
                if   (( battery <= 12 )); then 
                    battery_span="<span color=\"${ERROR_COLOR}\"><i> ${battery}</i></span>"
                elif (( battery<= 37 )); then 
                    battery_span="<span color=\"${WARNING_COLOR}\"><i> ${battery}</i></span>"
                elif (( battery <= 62 )); then 
                    battery_span="<i> ${battery}</i>"
                elif (( battery <= 87 )); then 
                    battery_span="<i> ${battery}</i>"
                elif (( battery <= 100 )); then 
                    battery_span="<i> ${battery}</i>"
                fi
            fi 

            ((connected_devices+=1))
        else 
            device_icon="󰂯"
            battery_span=""
        fi

        rofi_input+="$(colored-pango-icon "$device_icon") $device_name $battery_span\n"
    done

    rofi_message="${devices_count} founded device"
    (( devices_count > 1 )) && rofi_message+="s"
    (( connected_devices > 0 )) && rofi_message+="; $connected_devices connected"

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "${XDG_CONFIG_HOME}/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'i' \
        -p "󰂳 Bluetooth:" \
        -mesg "${rofi_message}" \
        -l $((devices_count + 1)) )

    if [ -z "${variant}" ]; then
        exit
    fi
    if (( variant == 0)); then 
        bluetoothctl --timeout 5 scan on >> /dev/null
        devices_menu
    elif (( variant <= devices_count )); then
        local -r selected_mac=$(sed "${variant}p" <<< "${device_id_list}")
        local -r selected_device_info=$(bluetoothctl info "$selected_mac")

        if grep -q "Connected: yes" <<< "$selected_device_info"; then
            bluetoothctl disconnect "${selected_mac}"  
        else
            grep -q "Trusted: no" <<< "$selected_device_info" \
                && bluetoothctl trust "$selected_mac"
            grep -q "Paired: no" <<< "$selected_device_info" \
                && bluetoothctl pair "$selected_mac"
            bluetoothctl connect "${selected_mac}"
        fi 
    fi
}

function main() {
    case $1 in
        "main") main_menu ;;
        "devices") devices_menu ;;
        *) exit 2 ;;
    esac
}

main "$@"
