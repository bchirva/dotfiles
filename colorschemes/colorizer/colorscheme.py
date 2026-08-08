"""Colorscheme dataclass"""

from dataclasses import dataclass
from typing import Any

from .color_blend import bright, dim, mix_color
from .consts import ANSI_COLOR_CODES, ANSI_COLOR_NAMES, ThemeStyle

# pylint: disable=missing-function-docstring,missing-class-docstring

@dataclass
class Color:
    base: str
    bright: str | None = None

    def __format__(self, format_spec: str) -> str:
        return format(self.base, format_spec)


@dataclass
class Foreground:
    base: str
    bright: str
    dim: str


@dataclass
class Background:
    base: str
    bright: str
    brightest: str
    dim: str


@dataclass
class Role:
    base: str
    bright: str
    dim: str
    background: str
    foreground: str
    ansi: int
    name: str


@dataclass
class Colorscheme:
    black: Color
    white: Color
    red: Color
    green: Color
    blue: Color
    yellow: Color
    cyan: Color
    magenta: Color
    orange: Color
    yellowgreen: Color
    cyangreen: Color
    azure: Color
    violet: Color
    rose: Color
    foreground: Foreground
    background: Background
    primary: Role
    secondary: Role
    warning: Role

    @classmethod
    def from_json(cls, json_data: dict[str, Any]) -> "Colorscheme":
        variant: ThemeStyle = ThemeStyle(json_data["variant"])

        color_names = [
            "black",
            "white",
            "red",
            "green",
            "blue",
            "yellow",
            "cyan",
            "magenta",
        ]

        base_colors = {name: json_data[name] for name in color_names}
        intermediate_colors = {
            "orange": mix_color(base_colors["red"], base_colors["yellow"], 0.5),
            "yellowgreen": mix_color(base_colors["yellow"], base_colors["green"], 0.5),
            "cyangreen": mix_color(base_colors["green"], base_colors["cyan"], 0.5),
            "azure": mix_color(base_colors["cyan"], base_colors["blue"], 0.5),
            "violet": mix_color(base_colors["blue"], base_colors["magenta"], 0.5),
            "rose": mix_color(base_colors["magenta"], base_colors["red"], 0.5),
        }
        colors = {
            name: Color(color)
            for name, color in {**base_colors, **intermediate_colors}.items()
        }
        colors["black"].bright = bright(base_colors["black"], variant, 0.3)
        colors["white"].bright = bright(base_colors["white"], variant, 0.3)
        colors["red"].bright = intermediate_colors["rose"]
        colors["green"].bright = intermediate_colors["yellowgreen"]
        colors["blue"].bright = intermediate_colors["azure"]
        colors["yellow"].bright = intermediate_colors["orange"]
        colors["cyan"].bright = intermediate_colors["cyangreen"]
        colors["magenta"].bright = intermediate_colors["violet"]

        background_base = ""
        foreground_base = ""
        match variant:
            case ThemeStyle.LIGHT:
                background_base = base_colors["white"]
                foreground_base = base_colors["black"]
            case ThemeStyle.DARK:
                background_base = base_colors["black"]
                foreground_base = base_colors["white"]

        background = Background(
            base=background_base,
            bright=bright(background_base, variant, 0.1),
            brightest=bright(background_base, variant, 0.2),
            dim=dim(background_base, variant, 0.1),
        )
        foreground = Foreground(
            base=foreground_base,
            bright=bright(foreground_base, variant, 0.2),
            dim=dim(foreground_base, variant, 0.2),
        )

        def resolve_role(name: str) -> Role:
            role_color_name = json_data["roles"][name]
            color = colors[role_color_name].base
            return Role(
                base=color,
                bright=mix_color(color, foreground.base, 0.9),
                dim=mix_color(color, background.base, 0.9),
                background=mix_color(background.base, color, 0.9),
                foreground=mix_color(foreground.base, color, 0.9),
                ansi=ANSI_COLOR_CODES[role_color_name],
                name=ANSI_COLOR_NAMES[role_color_name],
            )

        return cls(
            **colors,
            background=background,
            foreground=foreground,
            primary=resolve_role("primary"),
            secondary=resolve_role("secondary"),
            warning=resolve_role("warning"),
        )
