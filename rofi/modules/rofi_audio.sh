#!/bin/bash

source ~/.config/rofi/modules/utils_scripts/pulse_audio_helper.sh

DEVICE_TYPE=$1

case $DEVICE_TYPE in
    "output")   icon_name_prefix="audio"    ;;
    "input")    icon_name_prefix="mic"      ;;
    *) exit
esac

ROFI_INPUT="\
Volume +10%\0icon\x1f$icon_name_prefix-volume-high\n\
Volume -10%\0icon\x1f$icon_name_prefix-volume-low\n\
Mute\0icon\x1f$icon_name_prefix-volume-muted\n"

DEVICE_LIST_JSON=$(device_list $DEVICE_TYPE)
ACTIVE_DEVICE_JSON=$(active_device_info $DEVICE_TYPE)

DEVICE_ID_LIST=()
ACTIVE_DEVICE_IDX=0
for ((i = 0; i < $(jq ". | length" <<< $DEVICE_LIST_JSON); i++))
do
    DEVICE_ID_LIST[${#DEVICE_ID_LIST[@]}]=$(jq -r ".[$i].id" <<< $DEVICE_LIST_JSON)
    ROFI_INPUT="${ROFI_INPUT}$(jq -r ".[$i].name" <<< $DEVICE_LIST_JSON)\0icon\x1faudio-card\n"

    if [ "$(jq -r '.id' <<< $ACTIVE_DEVICE_JSON)" == "$(jq -r ".[$i].id" <<< $DEVICE_LIST_JSON)" ]; then
        ACTIVE_DEVICE_IDX=$i
    fi
done

MESSAGE="Active device: Volume $(jq -r ".volume" <<< $ACTIVE_DEVICE_JSON)"
if [[ $(jq -r ".muted" <<< $ACTIVE_DEVICE_JSON) == "yes" ]]; then
    MESSAGE="$MESSAGE (muted)"
fi

ROW_MODIFIERS="-a $(($ACTIVE_DEVICE_IDX + 3))"
if [[ $2 ]]; then
    ROW_MODIFIERS="$ROW_MODIFIERS -selected-row $2"
else
    ROW_MODIFIERS="$ROW_MODIFIERS -selected-row $(($ACTIVE_DEVICE_IDX + 3))"
fi

OPTION=$(echo -en $ROFI_INPUT | rofi -config "~/.config/rofi/modules/controls_config.rasi"\
    -i -dmenu -p "Audio control:" -no-custom -format 'i' $ROW_MODIFIERS -l $((${#DEVICE_ID_LIST[@]} + 3))\
    -mesg "$MESSAGE")

if [[ $OPTION ]]; then
    case $OPTION in
        0) 
            change_active_device_settings -v +10 $DEVICE_TYPE
            $0 $1 0 
            ;;
        1) 
            change_active_device_settings -v -10 $DEVICE_TYPE
            $0 $1 1 
            ;;
        2) 
            change_active_device_settings -m $DEVICE_TYPE
            $0 $1 2 
            ;;
        *) 
            change_active_device $DEVICE_TYPE "${DEVICE_ID_LIST[$(($OPTION - 3))]}"
            ;;
    esac
fi

