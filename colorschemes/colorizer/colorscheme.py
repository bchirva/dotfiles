"""Colorscheme dataclass"""

from dataclasses import dataclass
import re
from typing import Any

from .color_blend import bright, dim, mix_color
from .consts import (
    ANSI_COLOR_CODES,
    ANSI_COLOR_NAMES,
    BASE_COLOR_NAMES,
    COLOR_NAMES,
    REQUIRED_FIELDS,
    ThemeType,
)

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


@dataclass
class Role:
    base: str
    bright: str
    contrast: str
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
    chartreuse: Color
    spring: Color
    azure: Color
    violet: Color
    rose: Color
    foreground: Foreground
    background: Background
    accent: Role
    info: Role
    success: Role
    warning: Role
    error: Role

    @classmethod
    def from_json(
        cls, json_data: dict[str, Any], palette_name: str = "<palette>"
    ) -> "Colorscheme":
        fields = set(json_data)
        if fields != REQUIRED_FIELDS:
            missing = sorted(REQUIRED_FIELDS - fields)
            unknown = sorted(fields - REQUIRED_FIELDS)
            raise ValueError(
                f"{palette_name}: invalid palette fields; "
                f"missing={missing}, unknown={unknown}"
            )

        for name in BASE_COLOR_NAMES:
            if not isinstance(json_data[name], str) or not re.fullmatch(
                r"#[0-9a-fA-F]{6}", json_data[name]
            ):
                raise ValueError(f"{palette_name}: invalid {name}")

        try:
            theme_type = ThemeType(json_data["type"])
        except (TypeError, ValueError) as error:
            raise ValueError(f"{palette_name}: invalid type") from error

        accent = json_data["accent"]
        if accent not in COLOR_NAMES:
            raise ValueError(f"{palette_name}: invalid accent")

        base_colors = {name: json_data[name] for name in BASE_COLOR_NAMES}
        intermediate_colors = {
            "orange": mix_color(base_colors["red"], base_colors["yellow"], 0.5),
            "chartreuse": mix_color(base_colors["yellow"], base_colors["green"], 0.5),
            "spring": mix_color(base_colors["green"], base_colors["cyan"], 0.5),
            "azure": mix_color(base_colors["cyan"], base_colors["blue"], 0.5),
            "violet": mix_color(base_colors["blue"], base_colors["magenta"], 0.5),
            "rose": mix_color(base_colors["magenta"], base_colors["red"], 0.5),
        }
        colors = {
            name: Color(color)
            for name, color in {**base_colors, **intermediate_colors}.items()
        }
        colors["black"].bright = mix_color(base_colors["black"], base_colors["white"], 0.1)
        colors["white"].bright = mix_color(base_colors["white"], base_colors["black"], 0.1)
        colors["red"].bright = intermediate_colors["rose"]
        colors["green"].bright = intermediate_colors["chartreuse"]
        colors["blue"].bright = intermediate_colors["azure"]
        colors["yellow"].bright = intermediate_colors["orange"]
        colors["cyan"].bright = intermediate_colors["spring"]
        colors["magenta"].bright = intermediate_colors["violet"]

        if theme_type is ThemeType.LIGHT:
            background_base = base_colors["white"]
            foreground_base = base_colors["black"]
        else:
            background_base = base_colors["black"]
            foreground_base = base_colors["white"]

        background = Background(
            base=background_base,
            bright=bright(background_base, theme_type, 0.1),
            brightest=bright(background_base, theme_type, 0.2),
        )
        foreground = Foreground(
            base=foreground_base,
            bright=bright(foreground_base, theme_type, 0.1),
            dim=dim(foreground_base, theme_type, 0.1),
        )

        bright_color_names = {
            "red": "rose",
            "green": "chartreuse",
            "yellow": "orange",
            "cyan": "spring",
            "blue": "azure",
            "magenta": "violet",
        }

        def resolve_role(role_color_name: str) -> Role:
            color = colors[role_color_name].base
            return Role(
                base=color,
                bright=bright(color, theme_type, 0.1),
                contrast=mix_color(color, background.base, 0.1),
                background=mix_color(color, background.base, 0.3),
                foreground=mix_color(color, foreground.base, 0.3),
                ansi=ANSI_COLOR_CODES[role_color_name],
                name=ANSI_COLOR_NAMES[role_color_name],
            )

        semantic_colors = {
            "info": "blue",
            "success": "green",
            "warning": "yellow",
            "error": "red",
        }
        for role, color_name in semantic_colors.items():
            if accent == color_name:
                semantic_colors[role] = bright_color_names[color_name]

        return cls(
            **colors,
            background=background,
            foreground=foreground,
            accent=resolve_role(accent),
            **{role: resolve_role(color_name) for role, color_name in semantic_colors.items()},
        )
