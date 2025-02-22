#!/bin/bash

TIMESTAMP_FORMAT="%Y%m%d%H%M%S"
SCREENSHOTS_PATH="$HOME/Images/screenshots"
CLIPBOARD_CMD='xclip -selection clipboard -target image/png -i $f'
NOTIFICATION_CMD='notify-send -u normal -i accessories-screenshot "Screenshot" "saved in $f"'

function screenshot_select {
    scrot -s -d 1 -f "$SCREENSHOTS_PATH/screenshot_$TIMESTAMP_FORMAT.png" -e "${CLIPBOARD_CMD} & ${NOTIFICATION_CMD}"
}

function screenshot_focused {
    scrot -u -d 3 -f "$SCREENSHOTS_PATH/screenshot_$TIMESTAMP_FORMAT.png" -e "${CLIPBOARD_CMD} & ${NOTIFICATION_CMD}"
}

