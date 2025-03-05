#!/bin/bash

PASSWORDS=$(pass list | sed '1d' | sed 's/\(└\|─\|├\)//g' | sed 's/^ //g')
PASSWORDS_COUNT=$(wc -l <<< "$PASSWORDS")
ROFI_INPUT=""

while read -r line 
do 
    ROFI_INPUT="${ROFI_INPUT}${line}\0icon\x1fdialog-password-panel\n"
done <<< "$PASSWORDS"
ROFI_INPUT="${ROFI_INPUT}Generate new password\n"


variant=$(echo -en "$ROFI_INPUT" | rofi -markup-rows -config "$HOME/.config/rofi/modules/controls_config.rasi"\
    -i -dmenu -p "Password:" -no-custom -format 'i' -mesg "$ROFI_MESSAGE" -l $(( PASSWORDS_COUNT > 20 ? 20 : $(( PASSWORDS_COUNT + 1)) )) )

if [ ! $variant ]; then
    exit;
elif (( variant == PASSWORDS_COUNT )); then 
    PASSWORD_SERVICE=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" -dmenu -p "New password for:") 
    pass generate "$PASSWORD_SERVICE" 20
else 
    SELECTED_SERVICE="$(sed -n "${variant}p" <<< "$PASSWORDS")"
    pass -c "$SELECTED_SERVICE"
    notify-send -u normal -i dialog-password-panel "Password copied" "Password for $SELECTED_SERVICE copied to clipboard"
fi

