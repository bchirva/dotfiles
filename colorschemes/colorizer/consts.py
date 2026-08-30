"""Constants"""

# pylint: disable=missing-function-docstring

from enum import Enum

ANSI_CLEAR_LINE: str = "\x1b[2K"
ANSI_RESET_COLOR: str = "\033[0m"
BASE_COLOR_NAMES: tuple[str, ...] = (
    "black",
    "white",
    "red",
    "green",
    "blue",
    "yellow",
    "cyan",
    "magenta",
)
DERIVED_COLOR_NAMES: tuple[str, ...] = (
    "orange",
    "chartreuse",
    "spring",
    "azure",
    "violet",
    "rose",
)
COLOR_NAMES: tuple[str, ...] = BASE_COLOR_NAMES + DERIVED_COLOR_NAMES
REQUIRED_FIELDS: frozenset[str] = frozenset((*BASE_COLOR_NAMES, "type", "accent"))

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
    "chartreuse": 92,
    "orange": 93,
    "azure": 94,
    "violet": 95,
    "spring": 96,
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
    "chartreuse": "lightgreen",
    "orange": "lightyellow",
    "azure": "lightblue",
    "violet": "lightmagenta",
    "spring": "lightcyan",
}

class ThemeType(Enum):
    LIGHT = "light"
    DARK = "dark"
