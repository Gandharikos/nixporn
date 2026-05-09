#!/usr/bin/env python3
"""Regenerate sources/<colorscheme>.json from flake inputs."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "sources"

COLORSCHEME_INPUTS = {
    "catppuccin": "catppuccin-palette",
    "cyberdream": "cyberdream",
    "decay": "decay",
    "dracula": "dracula",
    "gruvbox": "gruvbox",
    "kanagawa": "kanagawa",
    "nordic": "nordic",
    "rose-pine": "rose-pine",
    "solarized-osaka": "solarized-osaka",
    "tokyonight": "tokyonight",
}

HEX_VALUE = r"(?:#[0-9A-Fa-f]{6}|NONE)"
ASSIGN_RE = re.compile(rf"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*['\"]({HEX_VALUE})['\"]")
TABLE_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*{\s*$")


def run(command: list[str]) -> str:
    result = subprocess.run(
        command,
        cwd=ROOT,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    )
    return result.stdout.strip()


def nixporn_json(attr: str) -> Any:
    expr = f"""
      let
        flake = builtins.getFlake (toString ./.);
        nixporn = flake.lib.nixporn;
      in nixporn.{attr}
    """
    return json.loads(run(["nix", "eval", "--impure", "--json", "--expr", expr]))


def input_path(input_name: str) -> Path:
    expr = f'(builtins.getFlake (toString ./.)).inputs."{input_name}".outPath'
    return Path(run(["nix", "eval", "--impure", "--raw", "--expr", expr]))


def flake_url(original: dict[str, Any]) -> str | None:
    if original.get("type") != "github":
        return None
    ref = f"/{original['ref']}" if "ref" in original else ""
    return f"github:{original['owner']}/{original['repo']}{ref}"


def source_info(input_name: str, metadata: dict[str, Any], paths: list[str]) -> dict[str, Any]:
    node = metadata["locks"]["nodes"][input_name]
    locked = node["locked"]
    info = {
        "input": input_name,
        "url": flake_url(node.get("original", {})),
        "rev": locked.get("rev"),
        "lastModified": locked.get("lastModified"),
        "narHash": locked.get("narHash"),
    }
    if paths:
        info["paletteFiles"] = paths
    return {k: v for k, v in info.items() if v is not None}


def extract_table(text: str, open_brace_index: int) -> str:
    depth = 0
    for index in range(open_brace_index, len(text)):
        char = text[index]
        if char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return text[open_brace_index + 1 : index]
    raise ValueError("unterminated Lua table")


def table_after(text: str, pattern: str) -> str:
    match = re.search(pattern, text, flags=re.S)
    if not match:
        raise ValueError(f"Lua table pattern not found: {pattern}")
    start = text.find("{", match.end() - 1)
    if start == -1:
        raise ValueError(f"Lua table opening brace not found: {pattern}")
    return extract_table(text, start)


def return_table_for_function(text: str, function_name: str) -> str:
    match = re.search(rf"local function {re.escape(function_name)}\s*\(\)", text)
    if not match:
        raise ValueError(f"Lua function not found: {function_name}")
    start = text.find("return", match.end())
    if start == -1:
        raise ValueError(f"Lua function has no return table: {function_name}")
    open_brace = text.find("{", start)
    if open_brace == -1:
        raise ValueError(f"Lua return has no table: {function_name}")
    return extract_table(text, open_brace)


def parse_lua_assignments(block: str) -> dict[str, str]:
    palette: dict[str, str] = {}
    stack: list[str] = []

    for raw_line in block.splitlines():
        line = raw_line.split("--", 1)[0].strip()
        if not line:
            continue
        if line.startswith("}"):
            if stack:
                stack.pop()
            continue

        assignment = ASSIGN_RE.match(line)
        if assignment:
            key = "_".join([*stack, assignment.group(1)])
            palette[key] = assignment.group(2)
            continue

        table = TABLE_RE.match(line)
        if table:
            stack.append(table.group(1))

    return palette


def read_lua_table(path: Path, pattern: str) -> dict[str, str]:
    return parse_lua_assignments(table_after(path.read_text(), pattern))


def parse_catppuccin(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "palette.json"
    data = json.loads((root / rel).read_text())
    variants: dict[str, dict[str, str]] = {}

    for variant, spec in data.items():
        if not isinstance(spec, dict):
            continue

        parsed = {}
        for name, value in spec.get("colors", {}).items():
            if isinstance(value, str) and re.fullmatch(HEX_VALUE, value):
                parsed[name] = value
            elif isinstance(value, dict) and isinstance(value.get("hex"), str):
                parsed[name] = value["hex"]

        for name, value in spec.get("ansiColors", {}).items():
            if not isinstance(value, dict):
                continue
            normal = value.get("normal", {})
            bright = value.get("bright", {})
            if isinstance(normal, dict) and isinstance(normal.get("hex"), str):
                parsed[f"ansi_{name}"] = normal["hex"]
            if isinstance(bright, dict) and isinstance(bright.get("hex"), str):
                parsed[f"ansi_bright_{name}"] = bright["hex"]

        if parsed:
            variants[variant] = parsed

    return variants, [rel]


def parse_cyberdream(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "lua/cyberdream/colors.lua"
    path = root / rel
    text = path.read_text()
    return (
        {
            "default": parse_lua_assignments(table_after(text, r"M\.default\s*=\s*{")),
            "light": parse_lua_assignments(table_after(text, r"M\.light\s*=\s*{")),
        },
        [rel],
    )


def parse_decay(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "lua/decay/core.lua"
    text = (root / rel).read_text()
    functions = {
        "default": "get_decay",
        "dark": "get_darker_decay",
        "decayce": "get_decayce",
        "cosmic": "get_cosmic_decay",
        "light": "get_light_decay",
    }
    return (
        {
            variant: parse_lua_assignments(return_table_for_function(text, function))
            for variant, function in functions.items()
        },
        [rel],
    )


def parse_dracula(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "README.md"
    text = (root / rel).read_text()
    section = text.split("### Dracula", 1)[1].split("###", 1)[0]
    palette = {}

    for line in section.splitlines():
        match = re.match(r"\|\s*([^|]+?)\s*\|\s*`(#[0-9A-Fa-f]{6})`", line)
        if not match:
            continue
        key = re.sub(r"[^a-z0-9]+", "_", match.group(1).strip().lower()).strip("_")
        palette[key] = match.group(2)

    return {"default": palette}, [rel]


def parse_gruvbox(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "colors/gruvbox.vim"
    text = (root / rel).read_text()
    raw = dict(
        re.findall(r"let s:gb\.([A-Za-z0-9_]+)\s*=\s*\['(#[0-9A-Fa-f]{6})'", text)
    )
    return {"dark": raw, "light": raw}, [rel]


def parse_kanagawa(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "lua/kanagawa/colors.lua"
    raw = read_lua_table(root / rel, r"local palette\s*=\s*{")
    return {variant: raw for variant in ["wave", "dragon", "lotus"]}, [rel]


def parse_nordic(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "lua/nordic/colors/nordic.lua"
    return {"default": read_lua_table(root / rel, r"local palette\s*=\s*{")}, [rel]


def parse_rose_pine(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    rel = "lua/rose-pine/palette.lua"
    text = (root / rel).read_text()
    return (
        {
            variant: parse_lua_assignments(table_after(text, rf"\b{variant}\s*=\s*{{"))
            for variant in ["main", "moon", "dawn"]
        },
        [rel],
    )


def parse_solarized_osaka(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    files = {
        "dark": "extras/lua/solarized_osaka_dark.lua",
        "light": "extras/lua/solarized_osaka_light.lua",
    }
    return (
        {
            variant: read_lua_table(root / rel, r"local colors\s*=\s*{")
            for variant, rel in files.items()
        },
        list(files.values()),
    )


def parse_tokyonight(root: Path) -> tuple[dict[str, dict[str, str]], list[str]]:
    files = {
        "day": "extras/lua/tokyonight_day.lua",
        "moon": "extras/lua/tokyonight_moon.lua",
        "night": "extras/lua/tokyonight_night.lua",
        "storm": "extras/lua/tokyonight_storm.lua",
    }
    return (
        {
            variant: read_lua_table(root / rel, r"local colors\s*=\s*{")
            for variant, rel in files.items()
        },
        list(files.values()),
    )


PARSERS = {
    "catppuccin": parse_catppuccin,
    "cyberdream": parse_cyberdream,
    "decay": parse_decay,
    "dracula": parse_dracula,
    "gruvbox": parse_gruvbox,
    "kanagawa": parse_kanagawa,
    "nordic": parse_nordic,
    "rose-pine": parse_rose_pine,
    "solarized-osaka": parse_solarized_osaka,
    "tokyonight": parse_tokyonight,
}


def variant_names(colorscheme: str, colorscheme_meta: dict[str, Any]) -> list[str]:
    variants = colorscheme_meta[colorscheme]["variants"]
    if not variants:
        return ["default"]
    return variants


def load_previous_variants(colorscheme: str, field: str) -> dict[str, dict[str, Any]]:
    path = SOURCES / f"{colorscheme}.json"
    if not path.exists():
        return {}

    data = json.loads(path.read_text())
    return {
        variant: entry.get(field, {})
        for variant, entry in data.get("variants", {}).items()
        if isinstance(entry.get(field, {}), dict)
    }


def first(palette: dict[str, Any], names: list[str]) -> Any | None:
    for name in names:
        if name in palette:
            return palette[name]
    return None


def pick(primary: dict[str, Any], fallback_palette: dict[str, Any], names: list[str], default: Any) -> Any:
    value = first(primary, names)
    if value is not None:
        return value
    value = first(fallback_palette, names)
    if value is not None:
        return value
    return default


def with_aliases(colorscheme: str, variant: str, palette: dict[str, Any]) -> dict[str, Any]:
    aliased = dict(palette)

    def alias(target: str, names: list[str]) -> None:
        value = first(palette, names)
        if value is not None:
            aliased[target] = value

    if colorscheme == "catppuccin":
        aliases = {
            "bg": ["base"],
            "bg_dark": ["mantle"],
            "bg_highlight": ["surface0"],
            "black": ["crust"],
            "comment": ["overlay0"],
            "cyan": ["sky"],
            "fg": ["text"],
            "fg_dark": ["subtext1"],
            "magenta": ["mauve"],
            "orange": ["peach"],
            "purple": ["mauve"],
            "white": ["text"],
        }
    elif colorscheme == "rose-pine":
        aliases = {
            "bg": ["base"],
            "bg_dark": ["surface"],
            "bg_highlight": ["overlay"],
            "comment": ["muted"],
            "cyan": ["foam"],
            "fg": ["text"],
            "fg_dark": ["subtle"],
            "green": ["pine"],
            "magenta": ["iris"],
            "orange": ["gold"],
            "purple": ["iris"],
            "red": ["love"],
            "yellow": ["gold"],
        }
    elif colorscheme == "dracula":
        aliases = {
            "bg": ["background"],
            "bg_highlight": ["selection", "current_line"],
            "fg": ["foreground"],
            "magenta": ["pink"],
        }
    elif colorscheme == "gruvbox" and variant == "dark":
        aliases = {
            "bg": ["dark0"],
            "bg_dark": ["dark0_hard"],
            "bg_highlight": ["dark1"],
            "fg": ["light1"],
            "fg_dark": ["light4"],
            "black": ["dark0"],
            "red": ["neutral_red"],
            "green": ["neutral_green"],
            "yellow": ["neutral_yellow"],
            "blue": ["neutral_blue"],
            "magenta": ["neutral_purple"],
            "purple": ["neutral_purple"],
            "cyan": ["neutral_aqua"],
            "orange": ["neutral_orange"],
            "white": ["light1"],
            "comment": ["gray_245"],
            "bright_black": ["gray_245"],
            "bright_red": ["bright_red"],
            "bright_green": ["bright_green"],
            "bright_yellow": ["bright_yellow"],
            "bright_blue": ["bright_blue"],
            "bright_magenta": ["bright_purple"],
            "bright_cyan": ["bright_aqua"],
            "bright_white": ["light0"],
        }
    elif colorscheme == "gruvbox" and variant == "light":
        aliases = {
            "bg": ["light0"],
            "bg_dark": ["light0_soft"],
            "bg_highlight": ["light1"],
            "fg": ["dark1"],
            "fg_dark": ["dark2"],
            "black": ["light0"],
            "red": ["neutral_red"],
            "green": ["neutral_green"],
            "yellow": ["neutral_yellow"],
            "blue": ["neutral_blue"],
            "magenta": ["neutral_purple"],
            "purple": ["neutral_purple"],
            "cyan": ["neutral_aqua"],
            "orange": ["neutral_orange"],
            "white": ["dark1"],
            "comment": ["dark4"],
            "bright_black": ["gray_245"],
            "bright_red": ["faded_red"],
            "bright_green": ["faded_green"],
            "bright_yellow": ["faded_yellow"],
            "bright_blue": ["faded_blue"],
            "bright_magenta": ["faded_purple"],
            "bright_cyan": ["faded_aqua"],
            "bright_white": ["dark0"],
        }
    elif colorscheme == "kanagawa" and variant == "wave":
        aliases = {
            "bg": ["sumiInk3"],
            "bg_dark": ["sumiInk0"],
            "bg_highlight": ["waveBlue1"],
            "fg": ["fujiWhite"],
            "fg_dark": ["oldWhite"],
            "comment": ["fujiGray"],
            "black": ["sumiInk3"],
            "red": ["autumnRed"],
            "orange": ["surimiOrange"],
            "yellow": ["boatYellow2"],
            "green": ["autumnGreen"],
            "cyan": ["waveAqua1"],
            "blue": ["crystalBlue"],
            "magenta": ["oniViolet"],
            "purple": ["oniViolet"],
            "pink": ["sakuraPink"],
            "white": ["fujiWhite"],
            "bright_black": ["sumiInk6"],
            "bright_red": ["samuraiRed"],
            "bright_green": ["springGreen"],
            "bright_yellow": ["carpYellow"],
            "bright_blue": ["springBlue"],
            "bright_magenta": ["springViolet1"],
            "bright_cyan": ["waveAqua2"],
            "bright_white": ["oldWhite"],
        }
    elif colorscheme == "kanagawa" and variant == "dragon":
        aliases = {
            "bg": ["dragonBlack3"],
            "bg_dark": ["dragonBlack0"],
            "bg_highlight": ["dragonBlack4"],
            "fg": ["dragonWhite"],
            "fg_dark": ["dragonGray"],
            "comment": ["dragonAsh"],
            "black": ["dragonBlack0"],
            "red": ["dragonRed"],
            "orange": ["dragonOrange"],
            "yellow": ["dragonYellow"],
            "green": ["dragonGreen2"],
            "cyan": ["dragonAqua"],
            "blue": ["dragonBlue2"],
            "magenta": ["dragonPink"],
            "purple": ["dragonViolet"],
            "white": ["dragonWhite"],
            "bright_black": ["dragonGray"],
        }
    elif colorscheme == "kanagawa" and variant == "lotus":
        aliases = {
            "bg": ["lotusWhite3"],
            "bg_dark": ["lotusWhite1"],
            "bg_highlight": ["lotusWhite5"],
            "fg": ["lotusInk1"],
            "fg_dark": ["lotusInk2"],
            "comment": ["lotusGray3"],
            "black": ["sumiInk3"],
            "red": ["lotusRed"],
            "orange": ["lotusOrange"],
            "yellow": ["lotusYellow"],
            "green": ["lotusGreen"],
            "cyan": ["lotusAqua"],
            "blue": ["lotusBlue4"],
            "magenta": ["lotusPink"],
            "purple": ["lotusViolet4"],
            "white": ["lotusInk1"],
            "bright_black": ["lotusGray3"],
            "bright_red": ["lotusRed2"],
            "bright_green": ["lotusGreen2"],
            "bright_yellow": ["lotusYellow2"],
            "bright_blue": ["lotusTeal2"],
            "bright_magenta": ["lotusViolet4"],
            "bright_cyan": ["lotusAqua2"],
            "bright_white": ["lotusInk2"],
        }
    elif colorscheme == "nordic":
        aliases = {
            "bg": ["gray1"],
            "bg_dark": ["gray2"],
            "bg_highlight": ["gray3"],
            "fg": ["white2"],
            "fg_dark": ["white1"],
            "comment": ["gray4"],
            "black": ["gray1"],
            "red": ["red_base"],
            "orange": ["orange_base"],
            "yellow": ["yellow_base"],
            "green": ["green_base"],
            "cyan": ["blue2"],
            "blue": ["blue1"],
            "magenta": ["magenta_base"],
            "purple": ["magenta_base"],
            "white": ["white2"],
            "bright_black": ["gray4"],
            "bright_blue": ["blue0"],
            "bright_cyan": ["cyan_base"],
            "bright_white": ["white3"],
        }
    else:
        aliases = {}

    for target, names in aliases.items():
        alias(target, names)

    return aliased


def normalize_palette(primary: dict[str, Any], fallback_palette: dict[str, Any]) -> dict[str, Any]:
    bg = pick(primary, fallback_palette, ["bg", "background", "base"], "#000000")
    bg_dark = pick(primary, fallback_palette, ["bg_dark", "contrast", "mantle", "bg_alt"], bg)
    bg_highlight = pick(
        primary,
        fallback_palette,
        ["bg_highlight", "cursorline", "surface0", "overlay"],
        bg_dark,
    )
    fg = pick(primary, fallback_palette, ["fg", "foreground", "text"], "#ffffff")
    fg_dark = pick(primary, fallback_palette, ["fg_dark", "subtext1", "grey", "comments"], fg)
    comment = pick(
        primary,
        fallback_palette,
        ["comment", "comments", "muted", "overlay0", "grey"],
        fg_dark,
    )
    red = pick(primary, fallback_palette, ["red", "love"], "#ff0000")
    orange = pick(primary, fallback_palette, ["orange", "peach"], red)
    yellow = pick(primary, fallback_palette, ["yellow", "gold"], orange)
    green = pick(primary, fallback_palette, ["green", "pine"], "#00ff00")
    cyan = pick(primary, fallback_palette, ["cyan", "foam", "teal", "sky"], green)
    blue = pick(primary, fallback_palette, ["blue", "sapphire"], cyan)
    magenta = pick(primary, fallback_palette, ["magenta", "mauve", "iris", "purple", "pink"], blue)
    purple = pick(primary, fallback_palette, ["purple", "mauve", "iris", "magenta"], magenta)
    black = pick(primary, fallback_palette, ["black", "crust"], bg_dark)
    white = pick(primary, fallback_palette, ["white", "text"], fg)
    bright_black = pick(
        primary,
        fallback_palette,
        ["bright_black", "brightblack", "overlay1", "surface2"],
        comment,
    )
    bright_red = pick(primary, fallback_palette, ["bright_red", "brightred"], red)
    bright_green = pick(primary, fallback_palette, ["bright_green", "brightgreen"], green)
    bright_yellow = pick(primary, fallback_palette, ["bright_yellow", "brightyellow"], yellow)
    bright_blue = pick(primary, fallback_palette, ["bright_blue", "brightblue"], blue)
    bright_magenta = pick(primary, fallback_palette, ["bright_magenta", "brightmagenta"], magenta)
    bright_cyan = pick(primary, fallback_palette, ["bright_cyan", "brightcyan"], cyan)
    bright_white = pick(primary, fallback_palette, ["bright_white", "brightwhite"], white)

    derived = {
        "base": bg,
        "bg": bg,
        "bg_dark": bg_dark,
        "bg_dark1": bg_dark,
        "bg_float": bg_dark,
        "bg_highlight": bg_highlight,
        "bg_popup": bg_dark,
        "bg_search": blue,
        "bg_sidebar": bg_dark,
        "bg_statusline": bg_dark,
        "bg_visual": bg_highlight,
        "black": black,
        "blue": blue,
        "blue0": blue,
        "blue1": cyan,
        "blue2": cyan,
        "blue5": cyan,
        "blue6": cyan,
        "blue7": bg_highlight,
        "border": black,
        "border_highlight": blue,
        "bright_black": bright_black,
        "bright_blue": bright_blue,
        "bright_cyan": bright_cyan,
        "bright_green": bright_green,
        "bright_magenta": bright_magenta,
        "bright_red": bright_red,
        "bright_white": bright_white,
        "bright_yellow": bright_yellow,
        "comment": comment,
        "crust": black,
        "cursor": {
            "baseColor": magenta,
            "outlineColor": bg_highlight,
            "watchBackgroundColor": orange,
        },
        "cyan": cyan,
        "dark3": comment,
        "dark5": bright_black,
        "error": red,
        "fg": fg,
        "fg_dark": fg_dark,
        "fg_float": fg,
        "fg_gutter": comment,
        "fg_sidebar": fg_dark,
        "flamingo": pick(primary, fallback_palette, ["flamingo"], orange),
        "green": green,
        "green1": green,
        "green2": cyan,
        "hint": cyan,
        "info": blue,
        "lavender": pick(primary, fallback_palette, ["lavender"], blue),
        "magenta": magenta,
        "magenta2": magenta,
        "mantle": bg_dark,
        "maroon": pick(primary, fallback_palette, ["maroon"], red),
        "mauve": pick(primary, fallback_palette, ["mauve"], magenta),
        "orange": orange,
        "overlay0": comment,
        "overlay1": comment,
        "overlay2": bright_black,
        "peach": pick(primary, fallback_palette, ["peach"], orange),
        "pink": pick(primary, fallback_palette, ["pink"], magenta),
        "purple": purple,
        "red": red,
        "red1": red,
        "rosewater": pick(primary, fallback_palette, ["rosewater"], orange),
        "sapphire": pick(primary, fallback_palette, ["sapphire"], cyan),
        "sky": pick(primary, fallback_palette, ["sky"], cyan),
        "subtext0": fg_dark,
        "subtext1": fg_dark,
        "surface0": bg_highlight,
        "surface1": bg_highlight,
        "surface2": bright_black,
        "teal": cyan,
        "terminal_black": bright_black,
        "text": fg,
        "todo": blue,
        "warning": yellow,
        "white": white,
        "yellow": yellow,
    }

    normalized = dict(fallback_palette)
    normalized.update(derived)
    normalized.update(primary)
    return normalized


def build_source(colorscheme: str, metadata: dict[str, Any], colorscheme_meta: dict[str, Any]) -> dict[str, Any]:
    input_name = COLORSCHEME_INPUTS[colorscheme]
    upstream: dict[str, dict[str, str]] = {}
    parsed_paths: list[str] = []

    if colorscheme in PARSERS:
        upstream, parsed_paths = PARSERS[colorscheme](input_path(input_name))

    previous_normalized = load_previous_variants(colorscheme, "normalized")
    previous_upstream = load_previous_variants(colorscheme, "upstream")
    variants = {}
    for variant in variant_names(colorscheme, colorscheme_meta):
        raw = upstream.get(variant, previous_upstream.get(variant, {}))
        normalized = normalize_palette(
            with_aliases(colorscheme, variant, raw),
            previous_normalized.get(variant, {}),
        )
        entry: dict[str, Any] = {"normalized": normalized}
        if raw:
            entry["upstream"] = raw
        variants[variant] = entry

    return {
        "schema": 1,
        "colorscheme": colorscheme,
        "source": source_info(input_name, metadata, parsed_paths),
        "generated": {
            "tool": "scripts/update-sources.py",
            "normalizedFrom": "parsed upstream palette with the previous source file as fallback",
            "note": "upstream is parsed from official source files when available; normalized is the palette consumed by nixporn modules.",
        },
        "variants": variants,
    }


def main() -> int:
    SOURCES.mkdir(exist_ok=True)
    metadata = json.loads(run(["nix", "flake", "metadata", "--json"]))
    colorscheme_meta = nixporn_json("colorschemeMeta")
    colorschemes = nixporn_json("supportedColorschemes")

    for colorscheme in colorschemes:
        source = build_source(colorscheme, metadata, colorscheme_meta)
        path = SOURCES / f"{colorscheme}.json"
        path.write_text(json.dumps(source, indent=2, sort_keys=True) + "\n")
        print(f"updated {path.relative_to(ROOT)}")

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as error:
        sys.stderr.write(error.stderr or str(error))
        raise SystemExit(error.returncode)
