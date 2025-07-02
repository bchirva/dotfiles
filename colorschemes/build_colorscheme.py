#!/usr/bin/env python3

# pylint: disable=missing-function-docstring

import sys
import argparse
import json
import os
from typing import Any

import numpy as np
from PIL import Image

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

CLEAR_LINE_ANSI: str = "\x1b[2K"
ANSI_RESET_COLOR: str = "\033[0m"

GENERAIONS: dict[str, str] = {
    "dunst.template": "theme.dunst.conf",
    "eww.template": "theme.eww.scss",
    "gtk.template": "theme.gtk.css",
    "gtkrc.template": "theme.gtkrc",
    "kitty.template": "theme.kitty.conf",
    "lazydocker.template": "theme.lazydocker.yml",
    "lazygit.template": "theme.lazygit.yml",
    "neovim.template": "theme.nvim.lua",
    "polybar.template": "theme.polybar.ini",
    "rmpc.template": "theme.rmpc.ron",
    "rofi.template": "theme.rofi.rasi",
    "sh.template": "theme.sh",
    "zathura.template": "theme.zathura",
    "yazi.template": "theme.yazi",
    "tmux.template": "theme.tmux.conf",
}

COLOR_ANSI_CODES: dict[str, int] = {
    "black": 30,
    "red": 31,
    "green": 32,
    "yellow": 33,
    "blue": 34,
    "magenta": 35,
    "cyan": 36,
    "white": 37,
}


def mix_color(hex_color1: str, hex_color2: str, ratio: float) -> str:

    def fix(num: float) -> int:
        return min(round(num), 255)

    color1: int = int(hex_color1[1:], 16)
    color2: int = int(hex_color2[1:], 16)
    r: int = fix((color1 >> 16 & 0xFF) * ratio + (color2 >> 16 & 0xFF) * (1 - ratio))
    g: int = fix((color1 >> 8 & 0xFF) * ratio + (color2 >> 8 & 0xFF) * (1 - ratio))
    b: int = fix((color1 & 0xFF) * ratio + (color2 & 0xFF) * (1 - ratio))

    result_color: int = (int(r) << 16) | (int(g) << 8) | int(b)
    return f"#{result_color:x}"


def lighten(hex_color: str, ratio: float) -> str:
    return mix_color(hex_color, "#ffffff", 1 - ratio)


def darken(hex_color: str, ratio: float) -> str:
    return mix_color(hex_color, "#000000", 1 - ratio)


def ansi_escape_color(color_name: str) -> int:
    return COLOR_ANSI_CODES[color_name]


def colorscheme_format(template: str, palette_json: Any) -> str:
    black: str = palette_json["black"]
    red: str = palette_json["red"]
    green: str = palette_json["green"]
    yellow: str = palette_json["yellow"]
    blue: str = palette_json["blue"]
    magenta: str = palette_json["magenta"]
    cyan: str = palette_json["cyan"]
    white: str = palette_json["white"]
    background: str = palette_json["background"]
    foreground: str = palette_json["foreground"]
    accent: str = palette_json[palette_json["accent"]]
    success: str = palette_json[palette_json["success"]]
    warning: str = palette_json[palette_json["warning"]]
    error: str = palette_json[palette_json["error"]]

    return template.format(
        black=black,
        red=red,
        green=green,
        yellow=yellow,
        blue=blue,
        magenta=magenta,
        cyan=cyan,
        white=white,
        black_variant=mix_color(black, white, 0.8),
        red_variant=mix_color(black, red, 0.3),
        green_variant=mix_color(black, green, 0.3),
        yellow_variant=mix_color(black, yellow, 0.3),
        blue_variant=mix_color(black, blue, 0.3),
        magenta_variant=mix_color(black, magenta, 0.3),
        cyan_variant=mix_color(black, cyan, 0.3),
        white_variant=mix_color(black, white, 0.3),
        bg_base=background,
        bg_view=mix_color(background, foreground, 0.9),
        bg_popup=mix_color(background, foreground, 0.8),
        bg_focused=mix_color(background, foreground, 0.7),
        bg_selected=mix_color(background, foreground, 0.6),
        fg_text=foreground,
        fg_highlighted=lighten(foreground, 0.2),
        fg_faded=darken(foreground, 0.3),
        color_accent=accent,
        color_success=success,
        color_warning=warning,
        color_error=error,
        color_on_accent=mix_color(
            accent,
            background,
            0.2,
        ),
        color_on_warning=mix_color(
            warning,
            background,
            0.2,
        ),
        color_on_error=mix_color(
            error,
            background,
            0.2,
        ),
        color_on_success=mix_color(
            success,
            background,
            0.2,
        ),
        color_accent_name=palette_json["accent"],
        color_warning_name=palette_json["warning"],
        color_error_name=palette_json["error"],
        color_success_name=palette_json["success"],
        color_accent_ansi=ansi_escape_color(palette_json["accent"]),
        color_warning_ansi=ansi_escape_color(palette_json["warning"]),
        color_error_ansi=ansi_escape_color(palette_json["error"]),
        color_succes_ansi=ansi_escape_color(palette_json["success"]),
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


def build_color_dotfiles(color_palette: dict, build_dir: str):
    for template, result in GENERAIONS.items():
        print(f"{CLEAR_LINE_ANSI}\tProcess {template}...", end="\r")

        with open(
            os.path.join(ROOT_DIR, "templates", template),
            "r",
            encoding="utf-8",
        ) as theme_file:

            theme_data = colorscheme_format(theme_file.read(), color_palette)

            with open(
                os.path.join(build_dir, result),
                "w",
                encoding="utf-8",
            ) as result_file:
                result_file.write(theme_data)
                result_file.close()


def colorize_wallpapers(color_palette: dict, build_dir: str):
    wallpapers_dir = os.path.join(build_dir, "wallpapers")
    if not os.path.isdir(wallpapers_dir):
        os.mkdir(wallpapers_dir)

    wallpapers_list = os.listdir(os.path.join(ROOT_DIR, "wallpapers"))
    for wallpaper in wallpapers_list:
        source_image = Image.open(os.path.join(ROOT_DIR, "wallpapers", wallpaper)).convert("L")
        themed_wallpaper = grayscale_colorize(
            source_image, color_palette[color_palette["accent"]]
        )
        themed_wallpaper.save(os.path.join(wallpapers_dir, wallpaper))


def main(params: dict[str, Any]):
    palettes_list: list[str] = []
    if params["all"]:
        palettes_list = os.listdir(os.path.join(ROOT_DIR, "palettes"))
    else:
        palettes_list = [
            name.strip() if name.strip().endswith(".json") else name.strip() + ".json"
            for name in params["select"].split(",")
        ]

    if not os.path.isdir("build"):
        os.mkdir("build")

    for palette in palettes_list:
        with open(
            os.path.join(ROOT_DIR, "palettes", palette), "r", encoding="utf-8"
        ) as palette_file:
            palette_json = json.load(palette_file)

            colorscheme_build_dir: str = os.path.join(ROOT_DIR, "build", palette.split(".")[0])
            if not os.path.isdir(colorscheme_build_dir):
                os.mkdir(colorscheme_build_dir)

            build_color_dotfiles(palette_json, colorscheme_build_dir)
            colorize_wallpapers(palette_json, colorscheme_build_dir)

            ansi_color_begin = f"\033[{ ansi_escape_color(palette_json["accent"])   }m"
            print(
                f"{CLEAR_LINE_ANSI}{ansi_color_begin} {palette.split('.')[0]}{ANSI_RESET_COLOR} colorscheme generated"
            )

    print("Done!")


parser = argparse.ArgumentParser(
    description="Build colorschemes for terminal & desktop environment",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("-s", "--select", type=str, help="select colorschemes to generate")
parser.add_argument("-a", "--all", action="store_true", help="generate all colorshemes")
args = parser.parse_args()

if len(sys.argv) == 1:
    args.all = True


if __name__ == "__main__":
    main(vars(args))
