#!/usr/bin/env sh

if ! command -v mpc >/dev/null; then 
    printf '\0'
    exit 0
fi

main() {
    case "$1" in 
        status) 
            song="$(mpc --format "%title% - %artist%" current)"
            if [ -n "${song}" ]; then 
                printf '%s\n' "󰝚 ${song}"
            else 
                printf '\0'
            fi
            ;;
        action) mpc toggle ;;
        *) exit 2
    esac 
}

main "$@"
