# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, dim, underline, BRIGHT

from . import theme

class Adaptive(ColorScheme):

    def use(self, context):
        fg, bg, attr = default_colors

        if context.directory:
            attr |= bold
            fg = theme.ACCENT_COLOR_NAME

        if context.link:
            fg = theme.WARNING_COLOR_NAME

        if context.executable and not context.directory:
            fg = theme.ACCENT_COLOR_NAME
            attr |= underline
            attr |= dim

        if context.error:
            fg = theme.ERROR_COLOR_NAME

        if context.hostname:
            fg = theme.WARNING_COLOR_NAME

        if context.highlight:
            attr |= reverse

        if context.selected:
            attr |= bold

        if context.reset:
            pass

        elif context.in_browser:
            if context.selected:
                attr = reverse

        elif context.in_titlebar and context.tab and context.good:
            attr |= reverse

        elif context.in_statusbar:
            if context.loaded or context.marked:
                attr |= reverse

        elif context.in_taskview:
            if context.selected:
                attr |= bold
                fg += BRIGHT
            if context.loaded:
                attr |= reverse

        return fg, bg, attr
