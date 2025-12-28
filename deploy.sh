#!/usr/bin/env bash

DOTFILES=(
    bat
    bottom
    bspwm
    dunst
    fzf
    git
    lazydocker
    lazygit
    mpd
    mpv
    npm
    nvim
    picom
    polybar
    qutebrowser
    rmpc
    rofi
    shell
    sxhkd
    tmux
    x11
    yazi
    zathura
    zsh
    bash_profile
    bashrc
    zshenv
)

ALL=false
LINK_BIN=false
LINK_APPS=false
GUI_THEME=false
SELECTED_ENTRIES=()

while (( $# > 0 )); do
    case "$1" in 
        -a|--all) ALL=true; SELECTED_ENTRIES=("${DOTFILES[@]}") ;;
        -b|--bin) LINK_BIN=true ;;
        -d|--desktop) LINK_APPS=true ;;
        -g|--gui) GUI_THEME=true ;;
        *) ! $ALL && SELECTED_ENTRIES+=("$1") ;;
    esac 
    shift 
done 

printf '%s\n' "Create directories..."
for dir in \
    ".cache/zsh" \
    ".config" \
    ".local/share/fonts"
do 
    mkdir -p "$HOME/$dir"
done

if $LINK_APPS || $ALL ; then
    printf '%s\n' "Link desktop files..."
    mkdir -p "$HOME/.local/share/applications"
    for app in "$PWD"/applications/* ; do 
        ln -snf "$app" "$HOME/.local/share/applications/"
    done
fi

if $LINK_BIN || $ALL ; then
    printf '%s\n' "Link executable scripts..."
    mkdir -p "$HOME/.local/bin"
    for script in "$PWD"/bin/* ; do 
        ln -snf "$script" "$HOME/.local/bin/"
    done 
fi

printf '%s\n' "Symlink dotfiles..."
for dot in "${SELECTED_ENTRIES[@]}"; do 
    DOTFILES_DIR=${XDG_CONFIG_HOME:-$HOME/.config}
    symlink="" backup="" i=1

    if [ -f "$PWD/$dot" ]; then 
        symlink="$HOME/.$dot"
    elif [ -d "$PWD/$dot" ]; then 
        symlink="$DOTFILES_DIR/$dot"
    else 
        continue 
    fi

    if [ -L "$symlink" ] && [ "$(readlink "$symlink")" = "$PWD/$dot" ]; then
        continue 
    fi

    if [ -e "$symlink" ]; then 
        backup="$symlink.backup"
        while [ -e "$backup" ]; do  
            ((i++))
            backup="$symlink.backup.$i"
        done 
    fi 

    if [ -n "$backup" ]; then 
        printf '%s\n' "Make backup $symlink -> $backup"
        mv "$symlink" "$backup"
    fi

    printf '%s\n' "Create symlink for $dot in $symlink"
    ln -snf "$PWD/$dot" "$symlink"
done

if $GUI_THEME || $ALL ; then
    mkdir -p "$HOME/.themes"
    mkdir -p "$HOME/.local/share/icons"

    printf '%s\n' "Generate colorschemes with GTK theme"
    python3 ./colorschemes/build_colorscheme.py --all --gtk

    [ -e "$HOME/.config/Kvantum" ] && mv "$HOME/.config/Kvantum" "$HOME/.config/Kvantum.backup"
    [ -e "$HOME/.config/gtk-2.0" ] && mv "$HOME/.config/gtk-2.0" "$HOME/.config/gtk-2.0.backup"
    [ -e "$HOME/.config/gtk-3.0" ] && mv "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-3.0.backup"

    ln -sf "$PWD"/ui/kvantum          "$HOME"/.config/Kvantum
    ln -sf "$PWD"/ui/gtk/config/*     "$HOME"/.config/
    ln -sf "$PWD"/ui/gtk/theme/Quartz "$HOME"/.themes/Quartz
else 
    printf '%s\n' "Generate colorschemes"
    python3 ./colorschemes/build_colorscheme.py --all
fi

if [ ! -e "$PWD/colorschemes/build/active" ]; then
    ln -sf "$PWD/colorschemes/build/onedark" "$PWD/colorschemes/build/active"
fi
