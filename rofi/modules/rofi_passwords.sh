#!/usr/bin/env bash

source "$HOME/.config/theme.sh"

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
    local -r MAX_PASSWORD_LINES=15
    local -r passwords=$(find "${PASSWORD_STORE_DIR:-$HOME/.password-store}" -type f -name '*.gpg' \
        | sed -e "s|^${PASSWORD_STORE_DIR:-$HOME/.password-store}/||" \
              -e 's|\.gpg$||' \
              -e '/^$/d')
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
        -markup-rows -i -dmenu -no-custom \
        -p "Password:" \
        -format 'i' \
        -theme-str "listview { columns: 2;} window { width: 600px; }" \
        -l $(( rows_count > MAX_PASSWORD_LINES ? MAX_PASSWORD_LINES : rows_count  )) )

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
        $(( idx_new)) )
            local -r password_service=$(rofi -config "$HOME/.config/rofi/modules/input_config.rasi" \
                -dmenu -p "New password for:" \
                -theme-str "window { width: 600px; }") 

            if [[ -z "${password_service}" ]]; then  
                exit
            fi

            if pass generate "${password_service}"; then 
                notify-send -u normal -i password-manager \
                    "Password generated" \
                    "Password for ${password_service} has been successfully generated"
                if (( sync_git_line )); then
                    if ! pass git push origin master > ~/passgit.log 2>&1 ; then 
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
        $(( idx_remove )) )
            local -r variant_remove=$(echo -en "${rofi_input_passwords}" \
                | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
                -markup-rows -i -dmenu -no-custom \
                -p "Password:" \
                -format 'i' \
                -theme-str "listview { columns: 2;} window { width: 500px; }" \
                -l $(( passwords_count > MAX_PASSWORD_LINES ? MAX_PASSWORD_LINES : passwords_count  )) )

            local -r selected_service="$(sed -n "$(( variant_remove + 1))p" <<< "${passwords}")"
            
            case $(echo -en "$(colored-icon pango 󰜺 ) Cancel \n$(colored-icon pango  "${ERROR_COLOR}" ) Remove\n" \
                    | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
                    -markup-rows -i -dmenu -no-custom \
                    -p "Remove ${selected_service}?" \
                    -format 'i' \
                    -theme-str "inputbar { children: [prompt]; }" \
                    -l 2) in 
                0) exit ;;
                1) 
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
                *) exit 1 ;;
                esac 
        ;;
        $(( idx_git)) ) 
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
        $(( idx_usb)) )
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
                -markup-rows -i -dmenu -no-custom \
                -p "USB drives:" \
                -format 'i' \
                -l "${usb_drives_count}" )"

            local -r usb_selected_mount=$(sed -n "$(( variant_usb + 1 ))p" <<< "${usb_drives}")

            if rsync -av --delete "$HOME/.password-store/" "${usb_selected_mount}/password-store/" ; then 
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
            local -r password_idx=$(( variant - (control_lines - 1) ))

            if (( password_idx > passwords_count )); then 
                exit 1
            fi 

            local -r selected_service="$(sed -n "${password_idx}p" <<< "${passwords}")"
            local -r service_data=$(pass show "${selected_service}")


            if grep -q '^otpauth://' <<<"${service_data}"; then
              local -r otp_present=true
            else
              local -r otp_present=false
            fi

            if [[ $(head -n 1 <<< "${service_data}") == otpauth://* ]]; then
              local -r only_otp=true
            else
              local -r only_otp=false
            fi

            function copy_password() {
                if pass -c "${selected_service}"; then 
                    notify-send -u normal -i password-manager \
                        "Password copied" \
                        "Password for ${selected_service} has been copied to clipboard"
                fi
            }

            function copy_onetime_password() {
                if pass otp -c "${selected_service}"; then 
                    notify-send -u normal -i password-manager \
                        "One-time password copied" \
                        "One-time password for ${selected_service} has been copied to clipboard"
                fi 
            }

            if ! ${otp_present}; then
                copy_password
            elif $only_otp; then
                copy_onetime_password
            else
                case $(echo -en "$(colored-icon pango  ) Password\n$(colored-icon pango 󰀠 ) One-time password\n" \
                    | rofi -config "$HOME/.config/rofi/modules/controls_config.rasi" \
                    -markup-rows -i -dmenu -no-custom \
                    -p "${selected_service}" \
                    -format 'i' \
                    -l 2) in 
                
                0) copy_password ;;
                1) copy_onetime_password ;;
                *) exit 1 ;;
                esac 
            fi
        ;;
    esac 
}

main "$@"

