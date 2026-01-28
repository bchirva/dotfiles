#!/usr/bin/env sh

cat "$XDG_DATA_HOME/rofi/emoji.txt" \
    | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-double-column.rasi" \
    -dmenu -p "Select emoji" \
    | cut -f 1 -d ' ' \
    | { IFS= read -r line; printf '%s' "$line"; } \
    | xclip -selection clipboard -in

