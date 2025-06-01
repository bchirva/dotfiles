#!/usr/bin/env bash

function usb-available() {
    local mountpoint output

    for disk in $(lsblk -dn -o NAME,TRAN \
        | awk '$2=="usb" {print $1}'); do
        for part in $(lsblk -ln -o NAME,TYPE /dev/"${disk}" \
            | awk '$2=="part" {print $1}'); do
            mountpoint="$(lsblk -no MOUNTPOINT /dev/"${part}")"
            if [[ -n "${mountpoint}" ]]; then 
                output="${output}${mountpoint}\n"
            fi
        done
    done
    echo -en "${output}"
}

function main() {  
    local -r passwords=$(find "${PASSWORD_STORE_DIR:-$HOME/.password-store}" -type f -name '*.gpg' \
        | sed -e "s|^${PASSWORD_STORE_DIR:-$HOME/.password-store}/||" \
          -e 's|\.gpg$||')
    local -r passwords_count=$(grep -cv '^$' <<< "${passwords}")

    local rofi_input 
    rofi_input="$(colored-icon pango  ) Add password for service...\n"

    if (( passwords_count > 0 )); then 
        rofi_input+="$(colored-icon pango  ) Remove password...\n"
        local -r remove_password_line=1
    fi

    if pass git status 2>/dev/null \
        && pass git remote -v 2>/dev/null | grep "origin" ; then 
        rofi_input+="$(colored-icon pango  ) Sync passwords from git\n"
        local -r sync_git_line=1
    fi

    local -r usb_drives=$(usb-available)
    if [[ -n "${usb_drives}" ]] && (( passwords_count > 0 )); then 
        rofi_input="${rofi_input}$(colored-icon pango 󰕓 ) Sync passwords to USB drive\n"
        local -r sync_usb_line=1
    fi

    local rofi_input_passwords=""
    if [[ -n "${passwords}" ]]; then 
        while read -r line 
        do 
            if [[ -n "${line}" ]]; then 
                rofi_input_passwords="${rofi_input_passwords}$(colored-icon pango  ) ${line}\n"
            fi
        done <<< "${passwords}"
    fi
    rofi_input="${rofi_input}${rofi_input_passwords}"
    local -r rows_count=$(( passwords_count + 1 + remove_password_line + sync_git_line + sync_usb_line ))

    local -r variant=$(echo -en "${rofi_input}" \
        | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
        -markup-rows -i -dmenu -p "Password:" -no-custom -format 'i' \
        -l $(( rows_count > 20 ? 20 : rows_count  )) )

    if [ ! "${variant}" ]; then
        exit;
    fi 

    local -r control_lines=$(( 1 + remove_password_line + sync_git_line + sync_usb_line  ))
    local -r idx_new=0
    local idx=1

    if (( remove_password_line )); then 
        local -r idx_remove=$(( idx ))
        (( idx += 1))
    else 
        local -r idx_remove=-1
    fi

    if (( sync_git_line )); then 
        local -r idx_git=$(( idx ))
        (( idx += 1))
    else 
        local -r idx_git=-1
    fi
    if (( sync_usb_line )); then 
        local -r idx_usb=$(( idx ))
        (( idx += 1))
    else 
        local -r idx_usb=-1
    fi

    case ${variant} in 
        ${idx_new}) 
            local -r password_service=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" -dmenu -p "New password for:") 
            if pass generate "${password_service}"; then 
                notify-send -u normal -i password-manager \
                    "Password generated" \
                    "Password for ${password_service} has been successfully generated"
                if (( sync_git_line )); then
                    if ! pass git push origin master ; then 
                        notify-send -u critical -i password-manager \
                            "Password synchronization failed" \
                            "Password for ${password_service} was generated, but failed to push to remote Git repository"
                    fi
                fi 
            else 
                notify-send -u critical -i password-manager \
                    "Password generation error" \
                    "Failed to generate password for ${password_service}"
            fi
        ;;
        ${idx_remove})
            local -r variant_remove=$(echo -en "${rofi_input_passwords}" \
                | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
                -markup-rows -i -dmenu -p "Password:" -no-custom -format 'i' \
                -l $(( passwords_count > 20 ? 20 : passwords_count  )) )

            local -r selected_service="$(sed -n "$(( variant_remove + 1))p" <<< "${passwords}")"
            if pass rm -f "${selected_service}"; then 
                notify-send -u normal -i password-manager \
                    "Password removed" \
                    "Password for ${selected_service} has been removed from the store"

                if (( sync_git_line )); then
                    if ! pass git push origin master ; then 
                        notify-send -u critical -i password-manager \
                            "Password synchronization failed" \
                            "Password for ${password_service} was generated, but failed to push to remote Git repository"
                    fi
                fi 

            fi
        ;;
        ${idx_git}) 
            if pass git pull origin master ; then 
                notify-send -u normal -i password-manager \
                    "Password sync complete" \
                    "Password store has been successfully synchronized with the remote Git repository"
            else 
                notify-send -u critical -i password-manager \
                    "Password sync error" \
                    "Failed to synchronize password store with the remote Git repository"
            fi
        ;;
        ${idx_usb})
            local -r usb_drives_count=$(grep -cv '^$' <<< "${usb_drives}")
            local rofi_input_usb
            while read -r line 
            do 
                if [[ -n "${line}" ]]; then 
                    rofi_input_usb="${rofi_input_usb}$(colored-icon pango 󰕓 ) ${line}\n"
                fi
            done <<< "${usb_drives}"

            local -r variant_usb="$(echo -en "${rofi_input_usb}" \
                | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
                -markup-rows -i -dmenu -p "USB drives:" -no-custom -format 'i' \
                -l "${usb_drives_count}" )"

            local -r usb_selected_mount=$(sed -n "$(( variant_usb + 1 ))p" <<< "${usb_drives}")

            if rsync -av --delete $HOME/.password-store/ "${usb_selected_mount}/password-store/" ; then 
                notify-send -u normal -i password-manager \
                    "Password backup complete" \
                    "Password store has been backed up to USB drive ${usb_selected_mount}"
            else 
                notify-send -u critical -i password-manager \
                    "Password sync error" \
                    "Failed to back up password store to USB drive ${usb_selected_mount}"
            fi
        ;;
        *)
            local -r password_idx=$(( variant - control_lines + 1 ))
            if (( password_idx <= passwords_count )); then 
                local -r selected_service="$(sed -n "${password_idx}p" <<< "${passwords}")"
                if pass -c "${selected_service}" ; then 
                    notify-send -u normal -i password-manager \
                        "Password copied" \
                        "Password for ${selected_service} has been copied to clipboard"
                fi
            else 
                exit 1
            fi
        ;;
    esac 
}

main "$@"

