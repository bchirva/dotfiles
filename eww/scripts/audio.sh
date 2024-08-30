#!/bin/bash

source ~/.config/eww/scripts/utils_scripts/pulse_audio_helper.sh

OPERATION=$1
DEVICE_TYPE=$2

case $OPERATION in
    "mute")  change_active_device_settings -m $DEVICE_TYPE ;;
    "level") change_active_device_settings -v $3 $DEVICE_TYPE ;;
    "status") echo $(active_device_info $DEVICE_TYPE) ;;
    "list") echo $(device_list $DEVICE_TYPE) ;;
    "choose") ~/.config/rofi/modules/rofi_audio.sh $DEVICE_TYPE ;;
esac

