#!/usr/bin/env bash 

source $HOME/.config/theme.sh

function main_menu {
    local -r total_status=$(network-ctrl system status)

    local rofi_input rofi_message
    if $total_status; then 
        rofi_input="$(colored-icon pango 󰖟 ) Network: <b>On</b>\n"

        local -r devices_json=$(network-ctrl device list)
        local -r devices_count=$(jq ". | length" <<< "$devices_json")
        local -r active_connections=$(network-ctrl connection list)
        
        if [[ "$active_connections" ]]; then
            local -r active_device=$(jq ".[0].device" <<< "$active_connections" \
                | sed "s/\"//g")
            local -r active_connection=$(jq ".[0].connection" <<< "$active_connections" \
                | sed "s/\"//g")
            rofi_message="Connected to <b>$active_connection</b> on <b>$active_device</b>"
        fi 

        local device_name device_status device_icon connection
        for device_idx in $(seq 0 $((devices_count - 1)))
        do
            device_name=$(jq ".[$device_idx].device" <<< "$devices_json" \
                | sed "s/\"//g")
            device_status=$(jq ".[$device_idx].status" <<< "$devices_json" \
                | sed "s/true/On/g" \
                | sed "s/false/Off/g")
            
            case $(jq ".[$device_idx].type" <<< "$devices_json" \
                | sed "s/\"//g") in
                "ethernet") 
                    if jq -e ".[$device_idx].status" <<< "$devices_json" > /dev/null; then 
                        device_icon="󰈁"
                    else 
                        device_icon="󰈂"
                    fi ;;
                "wifi")     
                    if jq -e ".[$device_idx].status" <<< "$devices_json" > /dev/null; then 
                        device_icon="󰖩"
                    else 
                        device_icon="󰖪"
                    fi ;;
                *) exit ;;
            esac 

            connection=$(jq ".[] | select (.device == \"${device_name}\") .connection" <<< "$active_connections" \
                | sed "s/\"//g")
            if [[ "$connection" ]]; then 
                connection="($connection)"
            fi

            rofi_input="${rofi_input}$(colored-icon pango ${device_icon}) ${device_name}: <b>${device_status}</b> <i>$connection</i>\n"
        done

        local -r wifi_available=$(( $(jq '[ .[] | select(.type == "wifi") ] | length' <<< "$devices_json") > 0 ? 1 : 0 ))
        if [ $wifi_available -ne 0 ]; then 
            rofi_input="${rofi_input}$(colored-icon pango 󱛆 ) WiFi networks menu\n"
        fi

        local -r vpns_json=$(network-ctrl vpn list)
        local -r vpns_count=$(jq ". | length" <<< "$vpns_json")

        local vpn_name vpn_status
        for vpn_idx in $(seq 0 $((vpns_count - 1)))
        do
            vpn_name=$(jq ".[$vpn_idx].name" <<< "$devices_json" \
                | sed "s/\"//g")
            vpn_status=$(jq ".[$vpn_idx].status" <<< "$devices_json" \
                | sed "s/true/On/g" \
                | sed "s/false/Off/g")
            rofi_input="${rofi_input}$(colored-icon pango 󰖂 )${vpn_name} <b>${vpn_status}</b>\n"
        done

        rofi_input="${rofi_input}$(colored-icon pango 󰑓 ) Restart NetworkManager service\n"
    else
        rofi_input="$(colored-icon pango 󰪎 ) Network: <b>Off</b>\n"
        rofi_message="Network disabled"
    fi

    if [[ -z "$rofi_message" ]]; then 
        rofi_message="No connection"; 
    fi

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -p "Network:" \
        -format 'i' \
        -mesg "${rofi_message}" \
        -l $((2 + devices_count + vpns_count + wifi_available)) )

    if [ ! "${variant}" ]; then
        exit;
    fi
    if (( variant == 0)); then 
        command=$(echo "$total_status" \
            | sed -e "s/true/off/g" -e "s/false/on/g")
        network-ctrl system toggle "${command}"
        if [[ "$command" == "on" ]]; then
            sleep 3
            main_menu 
        fi
    elif (( variant <= devices_count )); then
        network-ctrl device toggle \
            "$(jq ".[$(( variant - 1 ))].device" <<< "$devices_json" \
                | sed "s/\"//g")" \
            "$(jq ".[$(( variant - 1 ))].status" <<< "$devices_json" \
                | sed "s/true/off/g" \
                | sed "s/false/on/g")"
    elif (( variant == $((devices_count + 1)) )); then
        wifi_menu
    elif (( variant == $((devices_count + 2)) )); then
        pkexec systemctl restart NetworkManager
    else
        exit
    fi
}

function wifi_menu {
    local -r wifi_list_json=$(network-ctrl wifi list)
    local -r wifi_count=$(jq ". | length" <<< "$wifi_list_json")
    local -r active_connections=$(network-ctrl connection list)

    local rofi_input rofi_message
    local wifi_ssid wifi_security wifi_signal wifi_signal_icon connection
    for wifi_idx in $(seq 0 $((wifi_count - 1)) )
    do
        wifi_ssid=$(jq ".[$wifi_idx].ssid" <<< "${wifi_list_json}" | sed "s/\"//g")
        wifi_security=$(jq ".[$wifi_idx].security" <<< "${wifi_list_json}" | sed "s/\"//g")
        wifi_signal=$(jq ".[$wifi_idx].signal" <<< "${wifi_list_json}")

        if   (( wifi_signal <= 12 )); then 
            if jq -e ".[$wifi_idx].known" <<< "${wifi_list_json}" > /dev/null; then 
                wifi_signal_icon="󰤯"
            else 
                wifi_signal_icon="󰤬"
            fi
        elif (( wifi_signal <= 37 )); then 
            if jq -e ".[$wifi_idx].known" <<< "${wifi_list_json}" > /dev/null; then
                wifi_signal_icon="󰤟"
            else 
                wifi_signal_icon="󰤡"
            fi
        elif (( wifi_signal <= 62 )); then 
            if jq -e ".[$wifi_idx].known" <<< "${wifi_list_json}" > /dev/null; then
                wifi_signal_icon="󰤢"
            else
                wifi_signal_icon="󰤤"
            fi
        elif (( wifi_signal <= 87 )); then 
            if jq -e ".[$wifi_idx].known" <<< "${wifi_list_json}" > /dev/null; then 
                wifi_signal_icon="󰤥"
            else 
                wifi_signal_icon="󰤧"
            fi
        elif (( wifi_signal <= 100 )); then 
            if jq -e ".[$wifi_idx].known" <<< "${wifi_list_json}" > /dev/null; then
                wifi_signal_icon="󰤨"
            else 
                wifi_signal_icon="󰤪"
            fi
        fi

        connection=$(jq ".[] | select (.connection == \"${wifi_ssid}\") .device" <<< "$active_connections" \
            | sed "s/\"//g")
        if [[ "$connection" ]]; then 
            rofi_message="Connected to <b>$wifi_ssid</b> on <b>$connection</b>"
            connection="[$connection]"
        fi 

        rofi_input="${rofi_input}$(colored-icon pango "${wifi_signal_icon}") ${wifi_ssid} <i>(${wifi_security})</i> <b>$connection</b>\n"
    done

    rofi_input="${rofi_input}$(colored-icon pango 󰑓 ) Rescan WiFi networks\n"

    if [[ -z "$rofi_message" ]]; then 
        rofi_message="No connection"; 
    fi

    local -r variant=$(echo -en "$rofi_input" \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -p "WiFi:" \
        -format 'i' \
        -mesg "${rofi_message}" \
        -l $((wifi_count + 1)) )

    if [ ! "${variant}" ]; then 
        exit; 
    fi
    if (( variant == wifi_count)); then 
        nmcli device wifi rescan
        @0
    elif (( variant <= wifi_count )); then
        local -r selected_ssid=$(jq ".[$variant].ssid" <<< "${wifi_list_json}" \
            | sed "s/\"//g")
        if [[ "$(jq ".[] | select (.connection == \"${selected_ssid}\") .device" <<< "${active_connections}")" ]]; then
            network-ctrl wifi disconnect "${selected_ssid}"
        elif jq -e ".[$variant].known" <<< "${wifi_list_json}"; then 
            network-ctrl wifi connect "${selected_ssid}"
        else 
            ssid_password=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" \
                -dmenu -password \
                -p " " \
                -mesg "Password for WiFi network <b>${selected_ssid}</b>" )
            network-ctrl wifi connect "${selected_ssid}" "${ssid_password}"
        fi 
    fi
}

function main() {
    case $1 in
        "main") main_menu ;;
        "wifi") wifi_menu ;;
        *) exit 2 ;;
    esac
}

main "$@"
