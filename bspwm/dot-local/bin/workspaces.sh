#!/usr/bin/env sh

xrandr \
    | grep "\bconnected\b" \
    | while read -r line; do
    monitor_name=$(echo "${line}" | awk '{print $1}')
    bspc monitor "${monitor_name}" -d 1 2 3 4 5 
done
