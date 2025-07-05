"""Constants"""

# pylint: disable=missing-function-docstring

from enum import Enum

ANSI_CLEAR_LINE: str = "\x1b[2K"
ANSI_RESET_COLOR: str = "\033[0m"
ANSI_COLOR_CODES: dict[str, int] = {
    "black": 30,
    "red": 31,
    "green": 32,
    "yellow": 33,
    "blue": 34,
    "magenta": 35,
    "cyan": 36,
    "white": 37,
}

class ThemeStyle(Enum):
    LIGHT = "light"
    DARK = "dark"
