#!/usr/bin/env bash

function main() {
    local -r operation=$1

    case $operation in
        active) xkb-switch ;;
        next) xkb-switch -n ;;
    esac
}

main "$@"
