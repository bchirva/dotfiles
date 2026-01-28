#!/usr/bin/env sh

if ! command -v virsh >/dev/null; then 
    exit 1
fi

main() {
    virtual_machines="$(virsh -c qemu:///system list --all --name)"

    rofi_input() {
        printf '%s\n' "$virtual_machines" | while read -r line; do 
            printf '%s\n' "$(colored-pango-icon 󰟀 ) $line"
        done
    }

    row_count=$(printf '%s\n' "$virtual_machines" | wc -l)
    variant=$(rofi_input \
        | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi" \
        -markup-rows -i -dmenu -no-custom \
        -format 'p' \
        -p "󰟀 Virtual Machines:" \
        -l "$row_count")

    if [ -z "$variant" ]; then 
        exit 
    fi

    variant="$(printf '%s\n' "$variant" \
        | sed "s/^[^ ] *//")"

    if ! virsh -c qemu:///system list --all --name --state-running | grep -q "$variant"; then 
        virsh -c qemu:///system start "$variant" 
    fi

    virt-manager --connect qemu:///system --show-domain-console "$variant"
}

main "$@"
