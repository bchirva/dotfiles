#!/bin/bash

source $HOME/.config/rofi/modules/utils_scripts/pulse_audio_helper.sh
source $HOME/.config/rofi/modules/rofi_icon.sh

DEVICE_TYPE=$1

case $DEVICE_TYPE in
    "output")   
        ROFI_INPUT="$(pango_icon 󰝝 ) Volume +10%\n$(pango_icon 󰝞 ) Volume -10%\n$(pango_icon 󰝟 ) Mute\n"
        DEVICE_ICON="󱄠"
        ;;
    "input")    
        ROFI_INPUT="$(pango_icon 󰢴 ) Volume +10%\n$(pango_icon 󰢳 ) Volume -10%\n$(pango_icon  ) Mute\n"
        DEVICE_ICON=""
        ;;
    *) exit
esac

DEVICE_LIST_JSON=$(device_list $DEVICE_TYPE)
ACTIVE_DEVICE_JSON=$(active_device_info $DEVICE_TYPE)

DEVICE_ID_LIST=()
ACTIVE_DEVICE_IDX=0
for ((i = 0; i < $(jq ". | length" <<< $DEVICE_LIST_JSON); i++))
do
    DEVICE_ID_LIST[${#DEVICE_ID_LIST[@]}]=$(jq -r ".[$i].id" <<< $DEVICE_LIST_JSON)
    ROFI_INPUT="${ROFI_INPUT}$(pango_icon ${DEVICE_ICON} ) $(jq -r ".[$i].name" <<< $DEVICE_LIST_JSON)\n"

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
    -markup-rows -i -dmenu -p "Audio control:" -no-custom -format 'i' $ROW_MODIFIERS -l $((${#DEVICE_ID_LIST[@]} + 3))\
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

