#!/bin/bash

bluetooth_status=$(bluetoothctl show)
bluetooth_powered=$(grep -e "Powered" <<< ${bluetooth_status} | awk '{print $2}')
bluetooth_pairable=$(grep -e "Pairable" <<< ${bluetooth_status} | awk '{print $2}')
bluetooth_discoverable=$(grep -e "Discoverable" <<< ${bluetooth_status} | head -n 1 | awk '{print $2}')

rofi_input(){
    case $bluetooth_powered in
        "yes") echo -en "󰂯\tBluetooth: On\n"  ;;
        "no" ) echo -en "󰂲\tBluetooth: Off\n" ;;
        *) exit ;;
    esac

    case $bluetooth_pairable in
        "yes") echo -en "󰂯\tPairable: On\n"  ;;
        "no" ) echo -en "󰂲\tPairable: Off\n" ;;
        *) exit ;;
    esac
    case $bluetooth_discoverable in
        "yes") echo -en "󰂯\tDiscoverable: On\n"  ;;
        "no" ) echo -en "󰂲\tDiscoverable: Off\n" ;;
        *) exit ;;
    esac
}

variant=$(rofi_input | rofi -config "~/.config/rofi/modules/controls_config.rasi" \
    -i -dmenu -p "Bluetooth:" -no-custom -format 'i')

if ! [[ $variant ]]; then
    exit
else
    case $variant in
        0) 
            case $bluetooth_powered in
                "yes") bluetoothctl power off ;;
                "no" ) bluetoothctl power on  ;;
                *) exit ;;
            esac ;;
        1)
            case $bluetooth_pairable in
                "yes") bluetoothctl pairable off ;;
                "no" ) bluetoothctl pairable on  ;;
                *) exit ;;
            esac ;;
        2)
            case $bluetooth_discoverable in
                "yes") bluetoothctl discoverable off ;;
                "no" ) bluetoothctl discoverable on ;;
                *) exit ;;
            esac ;;
        *) exit ;;
    esac
fi
