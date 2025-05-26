#!/usr/bin/env bash

function main() {
    local -r monitors=$(xrandr | grep "\bconnected\b")
    local monitor_name=""
    
    while read -r line; do 
        monitor_name=$(awk '{print $1}' <<< "${line}")
        bspc monitor "${monitor_name}" -d 1 2 3 4 5 
    done <<< "${monitors}"
}

main "$@"
