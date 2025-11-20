#!/usr/bin/env sh

. "$XDG_CONFIG_HOME/shell/theme.sh"

TIMESTAMP_FORMAT="%Y%m%d-%H%M%S"
SCREENSHOTS_PATH="$HOME/Images/screenshots"
RECORDS_PATH="$HOME/Videos/records"
RECORD_PID_FILE="$XDG_RUNTIME_DIR/ffmpeg.record.pid"

# shellcheck disable=2016
CLIPBOARD_CMD='xclip -selection clipboard -target image/png -i $f'
# shellcheck disable=2016
NOTIFICATION_CMD='notify-send -u normal -i accessories-screenshot "Screenshot" "saved in $f"'

select_screen() {
    screens="$(xrandr --listactivemonitors \
        | sed -e '1d' -e 's/\(.*\) \([^ ]*\)/\2/' )"

    rofi_input=$(printf '%s\n' "$screens" \
        | while read -r line; do 
            printf '%s\n' "$(colored-icon 󰍹 ) $line"
        done)

    variant_screen=$(printf '%s\n' "$rofi_input" \
        | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
            -markup-rows -no-custom -i -dmenu \
            -format "i" \
            -p "Select screen" \
            -l "$(printf '%s\n' "${screens}" | wc -l )")

    if [ -n "$variant_screen" ]; then 
        variant_screen=$((variant_screen + 1))
        printf '%s\n' "$screens" | sed -n "${variant_screen}p"
    fi
}

rofi_str="\
$(colored-icon 󰇀 ) Shot focused window
$(colored-icon 󰍹 ) Shot whole screen
$(colored-icon 󰒉 ) Shot selected area or window
$(colored-icon  ) Record screen"

variant=$(printf '%s\n' "${rofi_str}" \
    | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
    -markup-rows -no-custom -i -dmenu \
    -format "i" \
    -p "󰹑 Screen capture:" \
    -l 4)

if [ -z "$variant" ]; then
    exit 1
fi

case $variant in
    0) 
        sleep 0.5
        scrot -u -f "$SCREENSHOTS_PATH/screenshot_$TIMESTAMP_FORMAT.png" \
            -e "$CLIPBOARD_CMD & $NOTIFICATION_CMD"
        ;;
    1) 
        screen="$(select_screen)"
        geometry=$(xrandr \
            | grep -A1 "^${screen}" \
            | grep -o '[0-9]\+x[0-9]\++[0-9]\++[0-9]\+' \
            | awk -F '[x+]' '{print $3 "," $4 "," $1 "," $2}')

        sleep 0.5
        scrot -a "${geometry}" -f "$SCREENSHOTS_PATH/screenshot_$TIMESTAMP_FORMAT.png" \
                        -e "$CLIPBOARD_CMD & $NOTIFICATION_CMD"
        ;;
    2) 
        sleep 0.5
        scrot -s -f "$SCREENSHOTS_PATH/screenshot_$TIMESTAMP_FORMAT.png" \
            -e "$CLIPBOARD_CMD & $NOTIFICATION_CMD"
        ;;
    3)
        if [ -f "$RECORD_PID_FILE" ]; then 
            ffmpeg_pid="$(head -n 1 "$RECORD_PID_FILE")"
            kill -INT "${ffmpeg_pid}" 
            wait "${ffmpeg_pid}"
            notify-send -u normal -i record-desktop "Screen recording has finished" \
                "Record saved in $(tail -n 1 "$RECORD_PID_FILE")"
            rm "$RECORD_PID_FILE"
            exit 0
        fi 

        screen="$(select_screen)"

        if [ -z "$screen" ]; then 
            exit 
        fi

        geometry_output=$(xrandr \
            | grep -A1 "^$screen" \
            | grep -o '[0-9]\+x[0-9]\++[0-9]\++[0-9]\+' \
            | awk -F '[x+]' '{print $1 "x" $2 "\t" $3 "," $4}')

        geometry_size=$(printf '%s\n' "$geometry_output" \
            | cut -f 1)
        geometry_offset=$(printf '%s\n' "$geometry_output" \
            | cut -f 2)

        inputs="-f x11grab -video_size $geometry_size -framerate 25 -i $DISPLAY+$geometry_offset"
        codecs="-c:v libx264"
        formats="-pix_fmt yuv420p"
        extra=""
        record_path="$RECORDS_PATH/record_$(date +$TIMESTAMP_FORMAT).mkv"

        if "$(pactl get-source-mute @DEFAULT_SOURCE@ | sed 's/^[^ ]* // ; s/yes/false/ ; s/no/true/' )" ; then 
            inputs="${inputs} -f pulse -ac 2 -i default"
            codecs="${codecs} -c:a aac"
            formats="${formats} -b:a 128k"
            extra="${extra} -preset ultrafast -threads 0"
        fi 
        
        sleep 0.5
        ffmpeg $inputs $codecs $formats $extra $record_path &

        printf '%s\n%s\n' "$!" "$record_path" > "$RECORD_PID_FILE"
        notify-send -u normal -i record-desktop "Screen $screen is recording" "Record will be saved in $record_path"
        ;;
    *) exit ;;
esac

