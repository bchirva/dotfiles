import os

import numpy as np
from PIL import Image

from .colorscheme import Colorscheme


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


def colorize_wallpapers(root_dir: str, palette_name: str, color_palette: Colorscheme):
    build_dir = os.path.join(root_dir, "build", palette_name, "wallpapers")
    # wallpapers_dir = os.path.join(build_dir, "wallpapers")
    if not os.path.isdir(build_dir):
        os.mkdir(build_dir)

    # wallpapers_list = os.listdir(os.path.join(ROOT_DIR, "wallpapers"))
    wallpapers_list = os.listdir(os.path.join(root_dir, "wallpapers"))
    for wallpaper in wallpapers_list:
        source_image = Image.open(
            os.path.join(root_dir, "wallpapers", wallpaper)
        ).convert("L")
        themed_wallpaper = grayscale_colorize(source_image, color_palette.primary)
        themed_wallpaper.save(os.path.join(build_dir, wallpaper))
