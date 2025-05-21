#!/bin/bash

OPERATION=$1
CHANNEL=$2

case $OPERATION in
    "status")
        ACTIVE_STATUS_JSON=$(audio-ctrl info "${CHANNEL}")
        MUTED=$(jq -r ".muted" <<< "${ACTIVE_STATUS_JSON}")
   
        if $MUTED ; then
            case $CHANNEL in
                "output") echo "" ;;
                "input") echo "󰍭" ;;
            esac
        else
            case $CHANNEL in
                "output") echo "" ;;
                "input") echo "󰍬" ;;
            esac
        fi
    ;;
    "menu")
        ~/.config/rofi/modules/rofi_audio.sh $CHANNEL 
    ;;
esac

