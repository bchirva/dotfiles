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
            if [ ! -d "$HOME/.local/share/nvim" ]; then
                curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            fi

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
            ln -sf $PWD/colorschemes/active/theme.sh                $PWD/bspwm/theme.sh
            ln -sf $PWD/colorschemes/active/theme.alacritty.toml    $PWD/alacritty/theme.toml
            ln -sf $PWD/colorschemes/active/theme.dunst.conf        $PWD/dunst/dunstrc.d/01-colors.conf
            ln -sf $PWD/colorschemes/active/theme.eww.scss          $PWD/eww/styles/theme.scss
            ln -sf $PWD/colorschemes/active/theme.nvim.lua          $PWD/nvim/lua/theme/colors.lua
            ln -sf $PWD/colorschemes/active/theme.polybar.ini       $PWD/polybar/theme.ini
            ln -sf $PWD/colorschemes/active/theme.rofi.rasi         $PWD/rofi/theme/colors.rasi
            ln -sf $PWD/colorschemes/active/theme.zathura           $PWD/zathura/themerc
            ln -sf $PWD/colorschemes/active/theme.sh                $PWD/zsh/theme.sh
            ln -sf $PWD/colorschemes/active/theme.gtkrc             $PWD/themes/Adaptish/gtk-2.0/colors.rc
            ln -sf $PWD/colorschemes/active/theme.gtk.css           $PWD/themes/Adaptish/gtk-3.0/colors.css
            ln -sf $PWD/colorschemes/active/theme.gtk.css           $PWD/themes/Adaptish/gtk-4.0/colors.css
            ;;
    esac
done






