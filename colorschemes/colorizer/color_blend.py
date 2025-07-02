"""Color blending functions"""

from .consts import ANSI_COLOR_CODES, ThemeStyle

# pylint: disable=missing-function-docstring


def mix_color(hex_color1: str, hex_color2: str, ratio: float) -> str:

    def fix(num: float) -> int:
        return min(round(num), 255)

    color1: int = int(hex_color1[1:], 16)
    color2: int = int(hex_color2[1:], 16)
    r: int = fix((color1 >> 16 & 0xFF) * ratio + (color2 >> 16 & 0xFF) * (1 - ratio))
    g: int = fix((color1 >> 8 & 0xFF) * ratio + (color2 >> 8 & 0xFF) * (1 - ratio))
    b: int = fix((color1 & 0xFF) * ratio + (color2 & 0xFF) * (1 - ratio))

    result_color: int = (int(r) << 16) | (int(g) << 8) | int(b)
    return f"#{result_color:06x}"


def lighten(hex_color: str, ratio: float) -> str:
    return mix_color(hex_color, "#ffffff", 1 - ratio)


def darken(hex_color: str, ratio: float) -> str:
    return mix_color(hex_color, "#000000", 1 - ratio)


def bright(hex_color: str, theme: ThemeStyle, ratio: float) -> str:
    match theme:
        case ThemeStyle.LIGHT:
            return darken(hex_color, ratio)
        case ThemeStyle.DARK:
            return lighten(hex_color, ratio)


def dim(hex_color: str, theme: ThemeStyle, ratio: float) -> str:
    match theme:
        case ThemeStyle.LIGHT:
            return lighten(hex_color, ratio)
        case ThemeStyle.DARK:
            return darken(hex_color, ratio)


def ansi_escape_color(color_name: str) -> int:
    return ANSI_COLOR_CODES[color_name]
