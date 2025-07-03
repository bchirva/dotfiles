"""Colorscheme dataclass"""

from dataclasses import dataclass
from typing import Any

from .color_blend import bright, dim, mix_color
from .consts import ANSI_COLOR_CODES, ThemeStyle

# pylint: disable=missing-function-docstring,missing-class-docstring

@dataclass
class Colorscheme:
    black: str
    white: str
    red: str
    green: str
    blue: str
    yellow: str
    cyan: str
    magenta: str

    black_bright: str
    white_bright: str
    red_bright: str
    green_bright: str
    blue_bright: str
    yellow_bright: str
    cyan_bright: str
    magenta_bright: str

    background_base: str
    background_view: str
    background_focused: str
    background_highlighted: str
    background_faded: str

    foreground_base: str
    foreground_highlighted: str
    foreground_faded: str

    primary: str
    primary_focused: str
    primary_highlighted: str
    on_primary: str
    primary_name: str
    primary_ansi: int

    secondary: str
    secondary_focused: str
    secondary_highlighted: str
    on_secondary: str
    secondary_name: str
    secondary_ansi: int

    warning: str
    warning_focused: str
    warning_highlighted: str
    on_warning: str
    warning_name: str
    warning_ansi: int

    @classmethod
    def from_json(cls, json_data: dict[str, Any]) -> "Colorscheme":
        variant: ThemeStyle = ThemeStyle(json_data["variant"])

        normal_colors_json = json_data["normal"]
        bright_colors_json = json_data.get("bright", {})
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

        def get_bright(color_name: str) -> str:
            return bright_colors_json.get(
                color_name, bright(normal_colors_json[color_name], variant, 0.3)
            )

        normal_colors = {name: normal_colors_json[name] for name in color_names}
        bright_colors = {f"{name}_bright": get_bright(name) for name in color_names}

        background_base = ""
        foreground_base = ""
        match variant:
            case ThemeStyle.LIGHT:
                background_base = normal_colors["white"]
                foreground_base = normal_colors["black"]
            case ThemeStyle.DARK:
                background_base = normal_colors["black"]
                foreground_base = normal_colors["white"]

        background_view = mix_color(background_base, foreground_base, 0.9)
        background_focused = mix_color(background_base, foreground_base, 0.8)
        background_highlighted = mix_color(background_base, foreground_base, 0.7)
        background_faded = dim(background_base, variant, 0.9)

        foreground_highlighted = bright(foreground_base, variant, 0.2)
        foreground_faded = mix_color(foreground_base, background_base, 0.8)

        def resolve_role(name: str) -> dict[str, Any]:
            role_color_name = json_data["roles"][name]
            color = normal_colors[role_color_name]
            return {
                f"{name}": color,
                f"{name}_focused": mix_color(color, foreground_base, 0.9),
                f"{name}_highlighted": mix_color(color, foreground_base, 0.8),
                f"on_{name}": mix_color(background_base, color, 0.9),
                f"{name}_name": role_color_name,
                f"{name}_ansi": ANSI_COLOR_CODES[role_color_name],
            }

        special_colors = {
            **resolve_role("primary"),
            **resolve_role("secondary"),
            **resolve_role("warning"),
        }

        return cls(
            **normal_colors,
            **bright_colors,
            background_base=background_base,
            background_view=background_view,
            background_focused=background_focused,
            background_highlighted=background_highlighted,
            background_faded=background_faded,
            foreground_base=foreground_base,
            foreground_highlighted=foreground_highlighted,
            foreground_faded=foreground_faded,
            **special_colors,
        )
