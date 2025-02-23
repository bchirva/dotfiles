#!/bin/bash

while getopts dls PARAMS
do
    case "${PARAMS}" in
        d)
            if [ ! -d "$HOME/.config" ]; then mkdir $HOME/.config; fi
            if [ ! -d "$HOME/.themes" ]; then mkdir $HOME/.themes; fi
            if [ ! -d "$HOME/.icons" ];  then mkdir $HOME/.themes; fi
            if [ ! -d "$HOME/.fonts" ];  then mkdir $HOME/.fonts; fi
            if [ ! -d "$HOME/.cache" ];  then mkdir $HOME/.cache; fi
        ;;
        l)
            CONFIG_DIR="$HOME/.config"
            ln -sf $PWD/alacritty       $CONFIG_DIR/alacritty 
            ln -sf $PWD/bottom          $CONFIG_DIR/bottom
            ln -sf $PWD/bspwm           $CONFIG_DIR/bspwm
            ln -sf $PWD/conky           $CONFIG_DIR/conky
            ln -sf $PWD/dunst           $CONFIG_DIR/dunst
            ln -sf $PWD/eww             $CONFIG_DIR/eww
            ln -sf $PWD/fzf             $CONFIG_DIR/fzf
            ln -sf $PWD/git             $CONFIG_DIR/git
            ln -sf $PWD/lazydocker      $CONFIG_DIR/lazydocker
            ln -sf $PWD/lazygit         $CONFIG_DIR/lazygit
            ln -sf $PWD/kitty           $CONFIG_DIR/kitty
            ln -sf $PWD/nvim            $CONFIG_DIR/nvim
            ln -sf $PWD/openbox         $CONFIG_DIR/openbox
            ln -sf $PWD/picom           $CONFIG_DIR/picom
            ln -sf $PWD/polybar         $CONFIG_DIR/polybar
            ln -sf $PWD/ranger          $CONFIG_DIR/ranger 
            ln -sf $PWD/rofi            $CONFIG_DIR/rofi
            ln -sf $PWD/sxhkd           $CONFIG_DIR/sxhkd 
            ln -sf $PWD/tmux            $CONFIG_DIR/tmux
            ln -sf $PWD/zathura         $CONFIG_DIR/zathura
            ln -sf $PWD/zsh             $CONFIG_DIR/zsh

            ln -sf $PWD/xprofile        $HOME/.xprofile  
            ln -sf $PWD/themes/Adaptish $HOME/.themes/Adaptish
            ;;
        s)
            THEME_DIR="$PWD/colorschemes/build/active"
            mkdir -p $PWD/dunst/dunstrc.d
            mkdir -p $PWD/lazydocker
            ln -sf $THEME_DIR/theme.alacritty.toml  $PWD/alacritty/theme.toml
            ln -sf $THEME_DIR/theme.dunst.conf      $PWD/dunst/dunstrc.d/01-colors.conf
            ln -sf $THEME_DIR/theme.eww.scss        $PWD/eww/styles/theme.scss
            ln -sf $THEME_DIR/theme.gtk.css         $PWD/themes/Adaptish/gtk-3.0/colors.css
            ln -sf $THEME_DIR/theme.gtk.css         $PWD/themes/Adaptish/gtk-4.0/colors.css
            ln -sf $THEME_DIR/theme.gtkrc           $PWD/themes/Adaptish/gtk-2.0/colors.rc
            ln -sf $THEME_DIR/theme.kitty.conf      $PWD/kitty/theme.conf
            ln -sf $THEME_DIR/theme.lazydocker.yml  $PWD/lazydocker/config.yml
            ln -sf $THEME_DIR/theme.lazygit.yml     $PWD/lazygit/theme.yml
            ln -sf $THEME_DIR/theme.ls-colors       $PWD/zsh/plugins/ls-colors/lscolors
            ln -sf $THEME_DIR/theme.less-colors     $PWD/zsh/plugins/man-colors/lesscolors
            ln -sf $THEME_DIR/theme.nvim.lua        $PWD/nvim/lua/theme/colors.lua
            ln -sf $THEME_DIR/theme.openbox         $PWD/themes/Adaptish/openbox-3/themerc
            ln -sf $THEME_DIR/theme.polybar.ini     $PWD/polybar/theme.ini
            ln -sf $THEME_DIR/theme.ranger.py       $PWD/ranger/colorschemes/theme.py
            ln -sf $THEME_DIR/theme.rofi.rasi       $PWD/rofi/theme/colors.rasi
            ln -sf $THEME_DIR/theme.sh              $PWD/bspwm/theme.sh
            ln -sf $THEME_DIR/theme.sh              $PWD/zsh/theme.sh
            ln -sf $THEME_DIR/theme.tmux.conf       $PWD/tmux/theme.conf
            ln -sf $THEME_DIR/theme.yazi            $PWD/yazi/theme.toml
            ln -sf $THEME_DIR/theme.nvim.lua        $PWD/yazi/colors.lua
            ln -sf $THEME_DIR/theme.zathura         $PWD/zathura/themerc
            ;;
        *) exit ;;
    esac
done






