#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/common_utils.sh"

function device_list {
    DEVICE_TYPE=$1
    case $DEVICE_TYPE in
        "output") 
            DEVICE_LIST=$(pactl list sinks)
            DEVICE_ID="Sink #"
        ;;
        "input")  
            DEVICE_LIST=$(pactl list sources)
            DEVICE_ID="Source #"
        ;;
        *) exit
    esac

    JSON_ARRAY="[]"

    for ((i = 0; i < $(grep -c "$DEVICE_ID" <<< $DEVICE_LIST); i++))
    do
        if [ $DEVICE_TYPE == "input" ] && [ $(grep -e "Monitor of Sink" <<< $DEVICE_LIST | head -n $(($i + 1)) | tail -n 1 | awk '{print $4}') != "n/a" ]; then
            continue
        fi

        ID=$(grep -e "Name:" <<< $DEVICE_LIST | head -n $(($i + 1)) | tail -n 1 | awk '{print $2}') 
        DEVICE=$(grep -e 'Active Port' <<< $DEVICE_LIST | head -n $(($i + 1)) | tail -n 1 | awk '{print $3}')
        NAME=$(grep -e $DEVICE <<< $DEVICE_LIST | head -n 1 | cut -d ':' -f 2 | cut -d '(' -f 1 | sed 's/^[[:blank:]]*//g;s/[[:blank:]]*$//g')
       
        JSON_ARRAY=$(jq  ". += [{id: \"$ID\", device: \"$DEVICE\", name: \"$NAME\"}]" <<< $JSON_ARRAY)
    done

    echo $JSON_ARRAY
}

function active_device_info {
    DEVICE_TYPE=$1

    case $DEVICE_TYPE in
        "output")
            ID=$(pactl get-default-sink)
            VOLUME_CMD="pactl get-sink-volume"
            MUTED_CMD="pactl get-sink-mute"
            ;;
        "input")
            ID=$(pactl get-default-source)
            VOLUME_CMD="pactl get-source-volume"
            MUTED_CMD="pactl get-source-mute"
            ;;
        *) exit
    esac

    VOLUME=$(eval $VOLUME_CMD $ID | awk '{print $5}' | sed 's/%//g')
    MUTED=$(eval $MUTED_CMD $ID | awk '{print $2}' | flag_to_bool)

    jq -n "{id: \"$ID\", volume: \"$VOLUME\", muted: \"$MUTED\"}"
}

function change_active_device {
    DEVICE_TYPE=$1
    DEVICE_ID=$2
    
    echo "Change Active Device: $DEVICE_TYPE $DEVICE_ID"

    case $DEVICE_TYPE in
        "output")
            SET_ACTIVE_DEVICE_CMD="pactl set-default-sink"
            MOVE_CHANNEL_TO_DEVICE_CMD="pactl move-sink-input"
            CHANNELS=$(pactl list sink-inputs short)
            ;;
        "input")
            SET_ACTIVE_DEVICE_CMD="pactl set-default-source"
            MOVE_CHANNEL_TO_DEVICE_CMD="pactl move-source-output"
            CHANNELS=$(pactl list source-outputs short)
            ;;
        *) exit
    esac

    eval "$SET_ACTIVE_DEVICE_CMD $DEVICE_ID"
    for ((i = 0; i < $(wc -l <<< $CHANNELS); i++))
    do
        eval "$MOVE_CHANNEL_TO_DEVICE_CMD $(head -n $(($i + 1)) <<< $CHANNELS | tail -n 1 | awk '{print $1}') $DEVICE_ID"
    done 
}

function change_active_device_settings {
    DEVICE_TYPE=${@: -1}

    case $DEVICE_TYPE in
    "output")
        ID=$(pactl get-default-sink)
        SET_VOLUME_CMD="pactl set-sink-volume"
        SET_MUTED_CMD="pactl set-sink-mute"
    ;;
    "input")
        ID=$(pactl get-default-source)
        SET_VOLUME_CMD="pactl set-source-volume"
        SET_MUTED_CMD="pactl set-source-mute"
    ;;
    *) exit
    esac

    while getopts v:m PARAMS
    do
        case "${PARAMS}" in
            v) eval "$SET_VOLUME_CMD $ID ${OPTARG}%" ;;
            m) eval "$SET_MUTED_CMD $ID toggle" ;;
        esac
    done
}

