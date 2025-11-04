#!/usr/bin/env sh

main() {
    case "$1" in 
        status) 
            song="$(mpc --format "%title% - %artist%" current)"
            if [ -n "${song}" ]; then 
                printf '%s\n' "󰝚 ${song}"
            else 
                printf '%s\n' "󰝛"
            fi
            ;;
        action) mpc toggle ;;
        *) exit 2
    esac 
}

main "$@"
