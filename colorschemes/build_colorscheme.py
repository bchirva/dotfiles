#!/usr/bin/env python3

# pylint: disable=missing-function-docstring

import argparse
import json
import os
import random
import sys
from typing import Any

from colorizer.colorize_dotfiles import build_color_dotfiles
from colorizer.colorscheme import Colorscheme
from colorizer.consts import ANSI_CLEAR_LINE, ANSI_RESET_COLOR
from colorizer.render_svg import render_gtk_assets

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))


def ensure_active_colorscheme(build_dir: str):
    active_link = os.path.join(build_dir, "active")
    active_target = os.path.realpath(active_link)

    if os.path.islink(active_link) and os.path.isdir(active_target):
        if os.path.dirname(active_target) == build_dir:
            return

    if os.path.lexists(active_link):
        print(f"Warning: {active_link} already exists and will not be changed")
        return

    colorscheme_dirs = [
        entry.name
        for entry in os.scandir(build_dir)
        if entry.name != "active" and entry.is_dir()
    ]
    if not colorscheme_dirs:
        print("Warning: no colorscheme build directories available for active link")
        return

    os.symlink(random.choice(colorscheme_dirs), active_link)


def main(params: dict[str, Any]):
    palettes_list: list[str] = []
    if params["all"]:
        palettes_list = os.listdir(os.path.join(ROOT_DIR, "palettes"))
    else:
        palettes_list = [
            name.strip() if name.strip().endswith(".json") else name.strip() + ".json"
            for name in params["select"].split(",")
        ]

    build_dir = os.path.join(ROOT_DIR, "build")
    if not os.path.isdir(build_dir):
        os.mkdir(build_dir)

    for palette in palettes_list:
        with open(
            os.path.join(ROOT_DIR, "palettes", palette), "r", encoding="utf-8"
        ) as palette_file:

            palette_name = palette.split(".")[0]
            colorscheme_build_dir: str = os.path.join(build_dir, palette_name)
            if not os.path.isdir(colorscheme_build_dir):
                os.mkdir(colorscheme_build_dir)

            colorscheme_dict: Colorscheme = Colorscheme.from_json(
                json.load(palette_file), palette_name
            )
            build_color_dotfiles(ROOT_DIR, palette_name, colorscheme_dict)

            if params["gtk"]:
                print(f"{ANSI_CLEAR_LINE}Generate GTK assets for {palette.split('.')[0]}")
                render_gtk_assets(ROOT_DIR, palette_name)

            ansi_color_begin = f"\033[{colorscheme_dict.accent.ansi}m"
            print(
                f"{ANSI_CLEAR_LINE}{ansi_color_begin} {palette.split('.')[0]}{ANSI_RESET_COLOR} colorscheme generated"
            )

    ensure_active_colorscheme(build_dir)
    print("Done!")


parser = argparse.ArgumentParser(
    description="Build colorschemes for terminal & desktop environment",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("-s", "--select", type=str, help="select colorschemes to generate")
parser.add_argument("-a", "--all", action="store_true", help="generate all colorshemes")
parser.add_argument("-g", "--gtk", action="store_true", help="generate GTK2/3/4 png-assets")
args = parser.parse_args()

if len(sys.argv) == 1:
    args.all = True


if __name__ == "__main__":
    main(vars(args))
