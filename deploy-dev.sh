#!/usr/bin/env sh

python3 ./colorschemes/build_colorscheme.py --all
if [ ! -e "$PWD/colorschemes/build/active" ]; then
    ln -sf "$PWD/colorschemes/build/onedark" "$PWD/colorschemes/build/active"
fi

stow -S \
    bat \
    bash \
    bottom \
    fzf \
    git \
    lazydocker \
    lazygit \
    nvim \
    shell \
    tmux \
    yazi \
    zsh

