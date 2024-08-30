#!/bin/bash

source ~/.config/rofi/modules/utils_scripts/network_manager_helper.sh

network_status=$(nmcli networking)
wifi_status=$(nmcli radio wifi)
active_network=""

echo "network_status: ${network_status}"
echo "wifi_status: ${wifi_status}"

if [[ "$wifi_status" == "enabled" ]]; then
    readarray -t wifi_networks <<< $(nmcli --fields ssid device wifi list | sed '1d' | sed '/^--/d')
    active_network=$(nmcli --fields state,type,connection device | sed '1d'\
        | grep "wifi" | grep -w "connected" | awk {'print $3'})

    echo "wifi_networks: ${wifi_networks}"
    echo "active_network: ${active_network}"
    
    for i in ${!wifi_networks[*]}
    do
        if [[ "${active_network}" == "$(awk '{$1=$1;print}' <<< ${wifi_networks[$i]})" ]]; then
            wifi_connected=$(($i+3))
            break
        fi
    done
fi

rofi_input=""
message=""
row_modifiers=""
case $network_status in
    "enabled")
        rofi_input="Network: On\0icon\x1fnetwork-connect\n"
        message="Network connected"
        case $wifi_status in
            "enabled")
                rofi_input="${rofi_input}Wi-Fi: On\0icon\x1fnetwork-wireless\n"
                rofi_input="${rofi_input}Rescan Wi-Fi networks\0icon\x1fview-refresh\n"
                for i in ${!wifi_networks[*]}; do
                    rofi_input="${rofi_input}${wifi_networks[$i]}\0icon\x1fnetwork-wireless\n" #todo: sygnal level
                done
                row_modifiers="-l $((${#wifi_networks[@]}+3)) -a ${wifi_connected} -selected-row ${wifi_connected}"
                message="${message} to Wi-Fi \"${active_network}\""
            ;;
            "disabled") 
                rofi_input="${rofi_input}Wi-Fi: Off\0icon\x1fnetwork-wireless-offline\n" 
                row_modifiers="-l 2"
                ;;
            *) exit ;;
        esac ;;
    "disabled") 
        "${rofi_input}Network: Off\0icon\x1fnetwork-disconnect\n" 
        message="Network disabled"
        ;;
    *) exit ;;
esac

variant=$(echo -en $rofi_input | rofi -config "~/.config/rofi/modules/controls_config.rasi"\
    -i -dmenu -p "Network:" -no-custom -format 'i' $row_modifiers -mesg "$message")

if ! [[ $variant ]]; then
    exit
else
    case $variant in
        0 ) 
            case $network_status in
                "enabled"  ) nmcli networking off ;;
                "disabled" ) nmcli networking on  ;;
                *) exit ;;
            esac
        ;;
        1 ) 
            case $wifi_status in
                "enabled"  ) nmcli radio wifi off ;;
                "disabled" ) nmcli radio wifi on  ;;
                *) exit ;;
            esac
        ;;
        2 )
            nmcli device wifi rescan
            $0
        ;;
        * )
            variant=$(($variant-3))
            if [[ $variant == $wifi_connected ]]; then
                nmcli connection down ${wifi_networks[$variant]}
                exit
            fi

            local known_connections=$(nmcli --fields name connection | sed '1d')
            if [[ "$known_connections" =~ "${wifi_networks[$variant]}" ]]; then
                nmcli connection up ${wifi_networks[$variant]}
            else
                local password=$(rofi -config "~/.config/rofi/modules/password.rasi" -dmenu -p "Password:" -password)
                nmcli device wifi connect ${wifi_networks[$variant]} password ${password}
            fi
        ;;
    esac
fi

# VPN 󰖂
