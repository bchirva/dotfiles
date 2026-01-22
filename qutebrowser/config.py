# pyright: reportMissingImports=false
# pyright: reportUndefinedVariable=false
# pylint: disable=undefined-variable

# General
config.load_autoconfig(False)
c.auto_save.session = False

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gh": "https://github.com/search?q={}&type=repositories&s=stars&o=desc",
    "yt": "https://www.youtube.com/results?search_query={}",
    "yx": "https://ya.ru/search/?text={}",
    "rt": "https://rutracker.org/forum/tracker.php?nm={}",
}
c.url.default_page = "qute://bookmarks"
c.url.start_pages = ["qute://bookmarks"]

# Keybindings
config.bind("<Ctrl-j>", "completion-item-focus --history next", mode="command")
config.bind("<Ctrl-k>", "completion-item-focus --history prev", mode="command")
config.bind(";v", "hint links spawn mpv --ytdl-raw-options=cookies-from-browser=brave {hint-url}")
config.bind("zz", "config-cycle tabs.show always never")
config.bind("zs", "config-cycle statusbar.show always in-mode")
config.bind("zf", "fullscreen")
config.bind("gh", "home")

# UI
c.fonts.tabs.selected = "bold"
c.tabs.position = "left"
c.tabs.padding = {"top": 8, "bottom": 8, "left": 4, "right": 4}
c.tabs.show = "always"
c.statusbar.padding = {"bottom": 4, "top": 4, "left": 4, "right": 4}
c.statusbar.show = "in-mode"
c.scrolling.smooth = True


c.colors.webpage.darkmode.enabled = True
config.source("theme.py")

# Privacy
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)

c.editor.command = [
    "kitty",
    "--single-instance",
    "-T",
    "auxiliary text edit",
    "nvim",
    "{file}",
    "+startinsert",
    "+call cursor({line}, {column})",
]

