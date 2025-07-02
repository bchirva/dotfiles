import os

from .colorscheme import Colorscheme
from .consts import ANSI_CLEAR_LINE, GENERAIONS


def build_color_dotfiles(root_dir: str, palette_name: str, color_palette: Colorscheme):
    for theme_file_name in GENERAIONS:
        print(f"{ANSI_CLEAR_LINE}\tProcess {theme_file_name} template...", end="\r")

        with open(
            os.path.join(root_dir, "templates", theme_file_name),
            "r",
            encoding="utf-8",
        ) as theme_file:
            theme_template = theme_file.read()
            theme_data = theme_template.format(**vars(color_palette))

            with open(
                os.path.join(root_dir, "build", palette_name, theme_file_name),
                "w",
                encoding="utf-8",
            ) as result_file:
                result_file.write(theme_data)
                result_file.close()
