#!/usr/bin/env bash

function main() {
    operation=$1

    case $operation in 
        "list")
            local workspaces result state monitor
            bspc subscribe desktop monitor report | while read -r _; do
                workspaces=()
                readarray -t workspaces <<< "$(bspc query -D)"

                result="[]"
                for workspace in "${workspaces[@]}"
                do
                    state="none"
                    if  grep -q "$workspace" <<< "$(bspc query -D -d focused)"; then
                        state="focused"
                    elif grep -q "$workspace" <<< "$(bspc query -D -d .occupied)"; then
                        state="active"
                    fi

                    monitor=$(bspc query -M --names -d "${workspace}")
                    result=$(echo "${result}" \
                        | jq ". + [{ \
                            id: \"$workspace\", \
                            state: \"$state\", \
                            monitor: \"$monitor\" \
                        }]")
                done
                echo "${result}"
            done
            ;;
        "switch")
            bspc desktop -f "$2"
        ;;
        *) exit ;;
    esac
}

main "$@"
