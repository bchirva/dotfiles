#!/bin/bash

operation=$1

case $operation in
    "active")
        echo $(xkb-switch)
    ;;
    "next")
        xkb-switch -n
    ;;
esac
