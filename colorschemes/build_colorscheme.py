#!/bin/python3

import argparse
import json
import os

parser = argparse.ArgumentParser(
    description="Build colorscheme set for rofi, eww and alacritty",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("-s", "--select", type=str, help="select colorschemes to generate")
parser.add_argument("-a", "--all", action="store_true", help="generate all colorshemes")

args = parser.parse_args()
config = vars(args)


def mix_color(color1, color2, ratio):
    color1num = int(color1[1:], 16)
    color2num = int(color2[1:], 16)
    r = ((color1num >> 16) & 0xFF) * ratio + ((color2num >> 16) & 0xFF) * (1 - ratio)
    g = ((color1num >> 8) & 0xFF) * ratio + ((color2num >> 8) & 0xFF) * (1 - ratio)
    b = (color1num & 0xFF) * ratio + (color2num & 0xFF) * (1 - ratio)
    result = (int(r) << 16) | (int(g) << 8) | int(b)
    return "#{:x}".format(result)


def lighten(color, ratio):
    return mix_color(color, "#ffffff", 1 - ratio)


def darken(color, ratio):
    return mix_color(color, "#000000", 1 - ratio)


# def colorscheme_format(template, colorscheme_json):
#     return template.format(
#             black = colorscheme_json["black"][0],
#             red = colorscheme_json["red"][0],
#             green = colorscheme_json["green"][0],
#             yellow = colorscheme_json["yellow"][0],
#             blue = colorscheme_json["blue"][0],
#             magenta = colorscheme_json["magenta"][0],
#             cyan = colorscheme_json["cyan"][0],
#             white = colorscheme_json["white"][0],
#             black_variant = colorscheme_json["black"][1],
#             red_variant = colorscheme_json["red"][1],
#             green_variant = colorscheme_json["green"][1],
#             yellow_variant= colorscheme_json["yellow"][1],
#             blue_variant = colorscheme_json["blue"][1],
#             magenta_variant = colorscheme_json["magenta"][1],
#             cyan_variant = colorscheme_json["cyan"][1],
#             white_variant = colorscheme_json["white"][1],
#
#             bg_base = colorscheme_json["background"]["base"],
#             bg_view = colorscheme_json["background"]["view"],
#             bg_popup = colorscheme_json["background"]["popup"],
#             bg_focused = colorscheme_json["background"]["focused"],
#             bg_selected = colorscheme_json["background"]["selected"],
#             fg_text = colorscheme_json["foreground"]["text"],
#             fg_highlighted = colorscheme_json["foreground"]["highlighted"],
#             fg_faded = colorscheme_json["foreground"]["faded"],
#
#             color_accent = colorscheme_json["accent"]["background"],
#             color_on_accent = colorscheme_json["accent"]["foreground"],
#             color_accent_name = colorscheme_json["accent"]["name"],
#             color_warning = colorscheme_json["warning"]["background"],
#             color_on_warning = colorscheme_json["warning"]["foreground"],
#             color_warning_name = colorscheme_json["warning"]["name"],
#             color_error = colorscheme_json["error"]["background"],
#             color_on_error = colorscheme_json["error"]["foreground"],
#             color_error_name = colorscheme_json["error"]["name"],
#             color_success = colorscheme_json["success"]["background"],
#             color_on_success = colorscheme_json["success"]["foreground"],
#             color_success_name = colorscheme_json["success"]["name"]
#     )


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
    )


generaions = [
    {"source": "alacritty.template", "result": "theme.alacritty.toml"},
    {"source": "dunst.template", "result": "theme.dunst.conf"},
    {"source": "eww.template", "result": "theme.eww.scss"},
    {"source": "gtk.template", "result": "theme.gtk.css"},
    {"source": "gtkrc.template", "result": "theme.gtkrc"},
    {"source": "lazydocker.template", "result": "theme.lazydocker.yml"},
    {"source": "lazygit.template", "result": "theme.lazygit.yml"},
    {"source": "neovim.template", "result": "theme.nvim.lua"},
    {"source": "openbox.template", "result": "theme.openbox"},
    {"source": "polybar.template", "result": "theme.polybar.ini"},
    {"source": "ranger.template", "result": "theme.ranger.py"},
    {"source": "rofi.template", "result": "theme.rofi.rasi"},
    {"source": "sh.template", "result": "theme.sh"},
    {"source": "zathura.template", "result": "theme.zathura"},
    {"source": "tmux.template", "result": "tmux.theme.conf"},
]

colorschemes_list = []
if config["all"]:
    colorschemes_list = os.listdir(".sources/palettes")
else:
    colorschemes_list = config["select"].split(",")

for colorscheme in colorschemes_list:
    print(f"Generate {colorscheme} colorscheme:")
    source_file = open(
        os.path.join("./.sources/palettes/", colorscheme), "r", encoding="utf-8"
    )
    colorscheme_json = json.load(source_file)

    name = colorscheme.split(".")[0]
    if not os.path.isdir(name):
        os.mkdir(name)

    for formated_theme in generaions:
        print(f"\tProcess {formated_theme['source']}...")

        theme_template = open(
            os.path.join("./.sources/templates/", formated_theme["source"]),
            "r",
            encoding="utf-8",
        ).read()
        theme_data = colorscheme_format(theme_template, colorscheme_json)

        with open(
            os.path.join(name, formated_theme["result"]), "w", encoding="utf-8"
        ) as result_file:
            result_file.write(theme_data)
            result_file.close()

print("Done!")
