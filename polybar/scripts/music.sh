#!/usr/bin/env bash

function main {
    case "$1" in 
        status) 
            local -r song="$(mpc --format "%title% - %artist%" current)"
            if [[ -n "${song}" ]]; then 
                echo "󰝚 ${song}"
            else 
                echo "󰝛"
            fi
            ;;
        action) mpc toggle ;;
        *) exit 2
    esac 
}

main "$@"
