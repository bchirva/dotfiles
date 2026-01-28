#!/usr/bin/env bash

python3 ./colorschemes/build_colorscheme.py --all --gtk
if [ ! -e "$PWD/colorschemes/build/active" ]; then
    ln -sf "$PWD/colorschemes/build/onedark" "$PWD/colorschemes/build/active"
fi

stow -S \
    bash \
    bat \
    bottom \
    bspwm \
    dunst \
    fzf \
    git \
    lazydocker \
    lazygit \
    mpd \
    mpv \
    npm \
    nvim \
    picom \
    polkit \
    polybar \
    qutebrowser \
    rmpc \
    rofi \
    shell \
    sxhkd \
    systemd \
    tmux \
    ui \
    x11 \
    yazi \
    zathura \
    zsh
