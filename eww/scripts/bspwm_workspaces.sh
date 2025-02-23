#!/bin/bash

operation=$1

case $operation in 
    "list")
        target_monitor=$2
        bspc subscribe desktop monitor report | while read -r _; do
            workspaces=()
            readarray -t workspaces <<< $(bspc query -D)

            result="[]"
            for workspace in "${workspaces[@]}"
            do
                state="none"
                if [[ "$(bspc query -D -d focused | grep "$workspace")" ]]; then
                    state="focused"
                elif [[ "$(bspc query -D -d .occupied | grep "$workspace")" ]]; then
                    state="active"
                fi
                monitor=$(bspc query -M --names -d $workspace)
                result=$(echo $result | jq ". + [{id: \"$workspace\", state: \"$state\", monitor: \"$monitor\"}]")
            done
            echo $result 
        done
        ;;
    "switch")
        bspc desktop -f $2
    ;;
    *) exit ;;
esac
