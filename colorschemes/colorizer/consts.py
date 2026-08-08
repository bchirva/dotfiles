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
    "rose": 91,
    "orange": 33,
    "yellowgreen": 92,
    "cyangreen": 96,
    "azure": 94,
    "violet": 95,
}

ANSI_COLOR_NAMES: dict[str, str] = {
    "black": "black",
    "red": "red",
    "green": "green",
    "yellow": "yellow",
    "blue": "blue",
    "magenta": "magenta",
    "cyan": "cyan",
    "white": "white",
    "rose": "lightred",
    "orange": "yellow",
    "yellowgreen": "lightgreen",
    "cyangreen": "lightcyan",
    "azure": "lightblue",
    "violet": "lightmagenta",
}

class ThemeStyle(Enum):
    LIGHT = "light"
    DARK = "dark"
