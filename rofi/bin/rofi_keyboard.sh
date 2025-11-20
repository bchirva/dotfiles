#!/usr/bin/env sh

. "$XDG_CONFIG_HOME/shell/theme.sh"

main() {
    layouts=$(xkb-switch --list)
    current_layout=$(xkb-switch -p)
    layouts_count=$(printf '%s\n' "$layouts" | wc -l)

    rofi_input() {
        for i in $layouts; do
            printf '%s\n' "$(colored-icon  ) $i"
        done
    }

    i=0
    for l in $layouts
    do
        if [ "$l" = "$current_layout" ]; then
            row_modifiers="-a $i -selected-row $i"
        fi
        i=$((i + 1))
    done

    # shellcheck disable=SC2086
    variant=$(rofi_input \
        | rofi -config "$XDG_CONFIG_HOME/rofi/dmenu-single-column.rasi"\
        -markup-rows -i -dmenu -no-custom \
        -format "i" \
        -p " Keyboard layouts:" \
        $row_modifiers \
        -l "$layouts_count" )

    if [ -n "$variant" ]; then
        selected_layout=$(printf '%s\n' "$layouts" | sed -n "$((variant + 1))p")
        xkb-switch -s "$selected_layout"
    fi
}

main "$@"
