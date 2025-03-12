#!/bin/bash

# Make config directories
if [ ! -d "$HOME/.cache" ];  then mkdir $HOME/.cache; fi
if [ ! -d "$HOME/.config" ]; then mkdir $HOME/.config; fi
if [ ! -d "$HOME/.fonts" ];  then mkdir $HOME/.fonts; fi
if [ ! -d "$HOME/.cache/zsh" ]; then mkdir -p $HOME/.cache/zsh/; fi

# Symlink config dotfiles
CONFIG_DIR="$HOME/.config"
ln -sf $PWD/fzf             $CONFIG_DIR/fzf
ln -sf $PWD/git             $CONFIG_DIR/git
ln -sf $PWD/lazygit         $CONFIG_DIR/lazygit
ln -sf $PWD/nvim            $CONFIG_DIR/nvim
ln -sf $PWD/ranger          $CONFIG_DIR/ranger 
ln -sf $PWD/tmux            $CONFIG_DIR/tmux
ln -sf $PWD/zsh             $CONFIG_DIR/zsh

ln -sf $PWD/xprofile        $HOME/.xprofile  

# Symlink theme to current
THEME_DIR="$PWD/colorschemes/build/active"
: ${DEFAULT_THEME:="onedark"}
if [ ! -d $THEME_DIR ]; then 
    ln -sf $PWD/colorschemes/build/${DEFAULT_THEME} $THEME_DIR
fi

ln -sf $THEME_DIR/theme.lazygit.yml     $PWD/lazygit/theme.yml
ln -sf $THEME_DIR/theme.ls-colors       $PWD/zsh/plugins/ls-colors/lscolors
ln -sf $THEME_DIR/theme.less-colors     $PWD/zsh/plugins/man-colors/lesscolors
ln -sf $THEME_DIR/theme.nvim.lua        $PWD/nvim/lua/theme/colors.lua
ln -sf $THEME_DIR/theme.ranger.py       $PWD/ranger/colorschemes/theme.py
ln -sf $THEME_DIR/theme.sh              $PWD/zsh/theme.sh
ln -sf $THEME_DIR/theme.tmux.conf       $PWD/tmux/theme.conf

