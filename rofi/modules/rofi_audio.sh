#!/bin/bash

DEVICE_TYPE=$1

case $DEVICE_TYPE in
    "output")   
        ROFI_INPUT="$(colored-icon pango 󰝝 ) Volume +10%\n$(colored-icon pango 󰝞 ) Volume -10%\n$(colored-icon pango 󰝟 ) Mute\n"
        DEVICE_ICON="󱄠"
        ;;
    "input")    
        ROFI_INPUT="$(colored-icon pango 󰢴 ) Volume +10%\n$(colored-icon pango 󰢳 ) Volume -10%\n$(colored-icon pango  ) Mute\n"
        DEVICE_ICON=""
        ;;
    *) exit
esac

DEVICE_LIST_JSON=$(audio-ctrl list "${DEVICE_TYPE}")
ACTIVE_DEVICE_JSON=$(audio-ctrl info "${DEVICE_TYPE}")

DEVICE_ID_LIST=()
ACTIVE_DEVICE_IDX=0
for ((i = 0; i < $(jq ". | length" <<< "${DEVICE_LIST_JSON}"); i++))
do
    DEVICE_ID_LIST[${#DEVICE_ID_LIST[@]}]=$(jq -r ".[$i].id" <<< "${DEVICE_LIST_JSON}")
    ROFI_INPUT="${ROFI_INPUT}$(colored-icon pango ${DEVICE_ICON} ) $(jq -r ".[$i].name" <<< "${DEVICE_LIST_JSON}")\n"

    if [ "$(jq -r '.id' <<< "${ACTIVE_DEVICE_JSON}")" == "$(jq -r ".[$i].id" <<< "${DEVICE_LIST_JSON}")" ]; then
        ACTIVE_DEVICE_IDX=$i
    fi
done

MESSAGE="Active device: Volume $(jq -r ".volume" <<< "${ACTIVE_DEVICE_JSON}")"
if [[ $(jq -r ".muted" <<< "${ACTIVE_DEVICE_JSON}") == "yes" ]]; then
    MESSAGE="$MESSAGE (muted)"
fi

ROW_MODIFIERS="-a $((ACTIVE_DEVICE_IDX + 3))"
if [[ $2 ]]; then
    ROW_MODIFIERS="${ROW_MODIFIERS} -selected-row $2"
else
    ROW_MODIFIERS="${ROW_MODIFIERS} -selected-row $((ACTIVE_DEVICE_IDX + 3))"
fi

OPTION=$(echo -en "${ROFI_INPUT}"| rofi -config "$HOME/.config/rofi/modules/controls_config.rasi"\
    -markup-rows -i -dmenu -p "Audio control:" -no-custom -format 'i' $ROW_MODIFIERS -l $((${#DEVICE_ID_LIST[@]} + 3))\
    -mesg "${MESSAGE}")

if [[ $OPTION ]]; then
    case $OPTION in
        0) 
            audio-ctrl set "${DEVICE_TYPE}" -v +10
            $0 $1 0 
            ;;
        1) 
            audio-ctrl set "${DEVICE_TYPE}" -v -10
            $0 $1 1 
            ;;
        2) 
            audio-ctrl set "${DEVICE_TYPE}" -m
            $0 $1 2 
            ;;
        *) 
            audio-ctrl choose "${DEVICE_TYPE}" "${DEVICE_ID_LIST[$((OPTION - 3))]}"
            ;;
    esac
fi

