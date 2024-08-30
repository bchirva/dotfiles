#!/bin/bash

operation=$1

case $operation in 
    "list")
        target_monitor=$2
        bspc subscribe desktop monitor report | while read -r _; do
            workspaces=()
            readarray -t workspaces <<< $(bspc query -D -m $target_monitor)

            result="[]"
            for workspace in "${workspaces[@]}"
            do
                state="none"
                if [[ "$(bspc query -D -d focused | grep "$workspace")" ]]; then
                    state="focused"
                elif [[ "$(bspc query -D -d .occupied | grep "$workspace")" ]]; then
                    state="active"
                fi
                result=$(echo $result | jq ". + [{id: \"$workspace\", state: \"$state\"}]")
            done
            echo $result
        done
        ;;
    "switch")
        bspc desktop -f $2
    ;;
    *) exit ;;
esac
