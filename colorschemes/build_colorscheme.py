#!/usr/bin/env python3

# pylint: disable=missing-function-docstring

import argparse
import json
import os

import numpy as np
from PIL import Image

CLEAR_LINE_ASCII = "\x1b[2K"
ANSI_RESET_COLOR = "\033[0m"

GENERAIONS = {
    "alacritty.template": "theme.alacritty.toml",
    "dunst.template": "theme.dunst.conf",
    "eww.template": "theme.eww.scss",
    "gtk.template": "theme.gtk.css",
    "gtkrc.template": "theme.gtkrc",
    "kitty.template": "theme.kitty.conf",
    "lazydocker.template": "theme.lazydocker.yml",
    "lazygit.template": "theme.lazygit.yml",
    "less-colors.template": "theme.less-colors",
    "ls-colors.template": "theme.ls-colors",
    "neovim.template": "theme.nvim.lua",
    "openbox.template": "theme.openbox",
    "polybar.template": "theme.polybar.ini",
    "ranger.template": "theme.ranger.py",
    "rofi.template": "theme.rofi.rasi",
    "sh.template": "theme.sh",
    "zathura.template": "theme.zathura",
    "yazi.template": "theme.yazi",
    "tmux.template": "theme.tmux.conf",
}

COLOR_ANSI_CODES = {
    "black": "30",
    "red": "31",
    "green": "32",
    "yellow": "33",
    "blue": "34",
    "magenta": "35",
    "cyan": "36",
    "white": "37",
}


def mix_color(hex_color1, hex_color2, ratio):
    color1num = int(hex_color1[1:], 16)
    color2num = int(hex_color2[1:], 16)
    r = ((color1num >> 16) & 0xFF) * ratio + ((color2num >> 16) & 0xFF) * (1 - ratio)
    g = ((color1num >> 8) & 0xFF) * ratio + ((color2num >> 8) & 0xFF) * (1 - ratio)
    b = (color1num & 0xFF) * ratio + (color2num & 0xFF) * (1 - ratio)
    result_color = (int(r) << 16) | (int(g) << 8) | int(b)
    return f"#{result_color:x}"


def lighten(hex_color, ratio):
    return mix_color(hex_color, "#ffffff", 1 - ratio)


def darken(hex_color, ratio):
    return mix_color(hex_color, "#000000", 1 - ratio)


def ansi_escape_color(color_name: str) -> str:
    return COLOR_ANSI_CODES[color_name]


def colorscheme_format(template, colorscheme_json):
    return template.format(
        black=colorscheme_json["black"],
        red=colorscheme_json["red"],
        green=colorscheme_json["green"],
        yellow=colorscheme_json["yellow"],
        blue=colorscheme_json["blue"],
        magenta=colorscheme_json["magenta"],
        cyan=colorscheme_json["cyan"],
        white=colorscheme_json["white"],
        black_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["white"], 0.8
        ),
        red_variant=mix_color(colorscheme_json["black"], colorscheme_json["red"], 0.3),
        green_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["green"], 0.3
        ),
        yellow_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["yellow"], 0.3
        ),
        blue_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["blue"], 0.3
        ),
        magenta_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["magenta"], 0.3
        ),
        cyan_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["cyan"], 0.3
        ),
        white_variant=mix_color(
            colorscheme_json["black"], colorscheme_json["white"], 0.3
        ),
        bg_base=colorscheme_json["background"],
        bg_view=mix_color(
            colorscheme_json["background"], colorscheme_json["foreground"], 0.9
        ),
        bg_popup=mix_color(
            colorscheme_json["background"], colorscheme_json["foreground"], 0.8
        ),
        bg_focused=mix_color(
            colorscheme_json["background"], colorscheme_json["foreground"], 0.7
        ),
        bg_selected=mix_color(
            colorscheme_json["background"], colorscheme_json["foreground"], 0.6
        ),
        fg_text=colorscheme_json["foreground"],
        fg_highlighted=lighten(colorscheme_json["foreground"], 0.2),
        fg_faded=darken(colorscheme_json["foreground"], 0.3),
        color_accent=colorscheme_json[colorscheme_json["accent"]],
        color_success=colorscheme_json[colorscheme_json["success"]],
        color_warning=colorscheme_json[colorscheme_json["warning"]],
        color_error=colorscheme_json[colorscheme_json["error"]],
        color_on_accent=mix_color(
            colorscheme_json[colorscheme_json["accent"]],
            colorscheme_json["background"],
            0.2,
        ),
        color_on_warning=mix_color(
            colorscheme_json[colorscheme_json["warning"]],
            colorscheme_json["background"],
            0.2,
        ),
        color_on_error=mix_color(
            colorscheme_json[colorscheme_json["error"]],
            colorscheme_json["background"],
            0.2,
        ),
        color_on_success=mix_color(
            colorscheme_json[colorscheme_json["success"]],
            colorscheme_json["background"],
            0.2,
        ),
        color_accent_name=colorscheme_json["accent"],
        color_warning_name=colorscheme_json["warning"],
        color_error_name=colorscheme_json["error"],
        color_success_name=colorscheme_json["success"],
        color_accent_ansi=ansi_escape_color(colorscheme_json["accent"]),
        color_warning_ansi=ansi_escape_color(colorscheme_json["warning"]),
        color_error_ansi=ansi_escape_color(colorscheme_json["error"]),
        color_succes_ansi=ansi_escape_color(colorscheme_json["success"]),
    )


def grayscale_colorize(source_image, hex_colors: str):
    hex_val = hex_colors.lstrip("#")
    r = int(hex_val[0:2], 16) / 255
    g = int(hex_val[2:4], 16) / 255
    b = int(hex_val[4:6], 16) / 255

    arr = np.array(source_image, dtype=np.float32) / 255.0

    tinted = np.zeros((arr.shape[0], arr.shape[1], 3), dtype=np.float32)
    tinted[..., 0] = arr * r
    tinted[..., 1] = arr * g
    tinted[..., 2] = arr * b
    return Image.fromarray((tinted * 255).astype(np.uint8))


def main(config):
    colorschemes_list = []
    if config["all"]:
        colorschemes_list = os.listdir("palettes")
    else:
        colorschemes_list = config["select"].split(",")

    if not os.path.isdir("build"):
        os.mkdir("build")

    for colorscheme in colorschemes_list:
        with open(
            os.path.join("./palettes/", colorscheme), "r", encoding="utf-8"
        ) as source_file:
            colorscheme_json = json.load(source_file)

            name = colorscheme.split(".")[0]
            colorscheme_dir = f"build/{name}"
            if not os.path.isdir(colorscheme_dir):
                os.mkdir(colorscheme_dir)

            for template, result in GENERAIONS.items():
                print(f"{CLEAR_LINE_ASCII}\tProcess {template}...", end="\r")

                with open(
                    os.path.join("./templates/", template),
                    "r",
                    encoding="utf-8",
                ) as theme_file:

                    theme_data = colorscheme_format(theme_file.read(), colorscheme_json)

                    with open(
                        os.path.join(colorscheme_dir, result),
                        "w",
                        encoding="utf-8",
                    ) as result_file:
                        result_file.write(theme_data)
                        result_file.close()

            wallpapers_dir = os.path.join(colorscheme_dir, "wallpapers")
            if not os.path.isdir(wallpapers_dir):
                os.mkdir(wallpapers_dir)

            wallpapers_list = os.listdir("wallpapers")
            for wallpaper in wallpapers_list:
                source_image = Image.open(
                    os.path.join("./wallpapers/", wallpaper)
                ).convert("L")
                themed_wallpaper = grayscale_colorize(
                    source_image, colorscheme_json[colorscheme_json["accent"]]
                )
                themed_wallpaper.save(os.path.join(wallpapers_dir, wallpaper))

            ansi_color_begin = (
                f"\033[{ ansi_escape_color(colorscheme_json["accent"])   }m"
            )
            print(
                f"{CLEAR_LINE_ASCII}{ansi_color_begin} {colorscheme.split('.')[0]}{ANSI_RESET_COLOR} colorscheme generated"
            )

    print("Done!")


parser = argparse.ArgumentParser(
    description="Build colorscheme set for rofi, eww and alacritty",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("-s", "--select", type=str, help="select colorschemes to generate")
parser.add_argument("-a", "--all", action="store_true", help="generate all colorshemes")

args = parser.parse_args()
config = vars(args)
if __name__ == "__main__":
    main(config)
