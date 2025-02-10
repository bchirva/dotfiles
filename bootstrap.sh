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
            ln -sf $PWD/alacritty       $HOME/.config/alacritty 
            ln -sf $PWD/bottom          $HOME/.config/bottom
            ln -sf $PWD/bspwm           $HOME/.config/bspwm
            ln -sf $PWD/conky           $HOME/.config/conky
            ln -sf $PWD/dunst           $HOME/.config/dunst
            ln -sf $PWD/eww             $HOME/.config/eww
            ln -sf $PWD/fzf             $HOME/.config/fzf
            ln -sf $PWD/git             $HOME/.config/git
            ln -sf $PWD/lazydocker      $HOME/.config/lazydocker
            ln -sf $PWD/lazygit         $HOME/.config/lazygit
            ln -sf $PWD/kitty           $HOME/.config/kitty
            ln -sf $PWD/nvim            $HOME/.config/nvim
            ln -sf $PWD/openbox         $HOME/.config/openbox
            ln -sf $PWD/picom           $HOME/.config/picom
            ln -sf $PWD/polybar         $HOME/.config/polybar
            ln -sf $PWD/ranger          $HOME/.config/ranger 
            ln -sf $PWD/rofi            $HOME/.config/rofi
            ln -sf $PWD/sxhkd           $HOME/.config/sxhkd 
            ln -sf $PWD/tmux            $HOME/.config/tmux
            ln -sf $PWD/zathura         $HOME/.config/zathura
            ln -sf $PWD/zsh             $HOME/.config/zsh

            ln -sf $PWD/xprofile        $HOME/.xprofile  
            ln -sf $PWD/themes/Adaptish $HOME/.themes/Adaptish
            ;;
        s)
            ln -sf $PWD/colorschemes/build/active/theme.alacritty.toml  $PWD/alacritty/theme.toml
            ln -sf $PWD/colorschemes/build/active/theme.dunst.conf      $PWD/dunst/dunstrc.d/01-colors.conf
            ln -sf $PWD/colorschemes/build/active/theme.eww.scss        $PWD/eww/styles/theme.scss
            ln -sf $PWD/colorschemes/build/active/theme.gtk.css         $PWD/themes/Adaptish/gtk-3.0/colors.css
            ln -sf $PWD/colorschemes/build/active/theme.gtk.css         $PWD/themes/Adaptish/gtk-4.0/colors.css
            ln -sf $PWD/colorschemes/build/active/theme.gtkrc           $PWD/themes/Adaptish/gtk-2.0/colors.rc
            ln -sf $PWD/colorschemes/build/active/theme.kitty.conf      $PWD/kitty/theme.conf
            ln -sf $PWD/colorschemes/build/active/theme.lazydocker.yml  $PWD/lazydocker/config.yml
            ln -sf $PWD/colorschemes/build/active/theme.lazygit.yml     $PWD/lazygit/theme.yml
            ln -sf $PWD/colorschemes/build/active/theme.nvim.lua        $PWD/nvim/lua/theme/colors.lua
            ln -sf $PWD/colorschemes/build/active/theme.openbox         $PWD/themes/Adaptish/openbox-3/themerc
            ln -sf $PWD/colorschemes/build/active/theme.polybar.ini     $PWD/polybar/theme.ini
            ln -sf $PWD/colorschemes/build/active/theme.ranger.py       $PWD/ranger/colorschemes/theme.py
            ln -sf $PWD/colorschemes/build/active/theme.rofi.rasi       $PWD/rofi/theme/colors.rasi
            ln -sf $PWD/colorschemes/build/active/theme.sh              $PWD/bspwm/theme.sh
            ln -sf $PWD/colorschemes/build/active/theme.sh              $PWD/zsh/theme.sh
            ln -sf $PWD/colorschemes/build/active/theme.tmux.conf       $PWD/tmux/theme.conf
            ln -sf $PWD/colorschemes/build/active/theme.zathura         $PWD/zathura/themerc
            ;;
        *) exit ;;
    esac
done






