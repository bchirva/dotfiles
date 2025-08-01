"""Render gtk .png assets from svg-source file"""
import os
import subprocess

# pylint: disable=missing-function-docstring,missing-class-docstring

def render_gtk_assets(root_dir: str, palette_name: str):
    subprocess.run(
        [
            "bash",
            os.path.join(root_dir, "colorizer", "render_svg_gtk_assets.sh"),
            os.path.join(root_dir, "build", palette_name),
        ],
        check=True,
    )
