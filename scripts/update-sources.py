#!/usr/bin/env python3
"""Regenerate sources/<colorscheme>.json from packaged theme sources."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "sources"

SOURCE_ORIGINS = {
    "catppuccin": "package source",
    "cyberdream": "package source",
    "decay": "package source",
    "dracula": "package source",
    "gruvbox": "package source",
    "kanagawa": "package source",
    "nordic": "package source",
    "rose-pine": "package source",
    "solarized-osaka": "package source",
    "tokyonight": "package source",
}

SOURCE_URLS = {
    "catppuccin": "github:catppuccin/palette",
    "cyberdream": "github:scottmckendry/cyberdream.nvim",
    "decay": "github:decaycs/decay.nvim",
    "dracula": "github:Mofiqul/dracula.nvim",
    "gruvbox": "github:morhetz/gruvbox",
    "kanagawa": "github:rebelot/kanagawa.nvim",
    "nordic": "github:andersevenrud/nordic.nvim",
    "rose-pine": "github:rose-pine/neovim",
    "solarized-osaka": "github:craftzdog/solarized-osaka.nvim",
    "tokyonight": "github:folke/tokyonight.nvim",
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


def source_expr(colorscheme: str) -> str:
    source = json.loads((SOURCES / f"{colorscheme}.json").read_text())["source"]
    url = source["url"]
    if not url.startswith("github:"):
        raise ValueError(f"unsupported source URL for {colorscheme}: {url}")

    owner, repo = url.removeprefix("github:").split("/", 1)
    return f"""
      builtins.fetchTree {{
        type = "github";
        owner = "{owner}";
        repo = "{repo}";
        rev = "{source["rev"]}";
        narHash = "{source["narHash"]}";
      }}
    """


def source_path(colorscheme: str) -> Path:
    path = run(
        [
            "nix",
            "eval",
            "--impure",
            "--raw",
            "--expr",
            f"({source_expr(colorscheme)}).outPath",
        ]
    )
    return Path(path)


def source_info(colorscheme: str, paths: list[str]) -> dict[str, Any]:
    source = json.loads((SOURCES / f"{colorscheme}.json").read_text())["source"]
    info = {
        "source": SOURCE_ORIGINS[colorscheme],
        "url": SOURCE_URLS[colorscheme],
        "rev": source.get("rev"),
        "narHash": source.get("narHash"),
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
    if not (root / rel).exists():
        files = {
            "latte": "lua/catppuccin/palettes/latte.lua",
            "frappe": "lua/catppuccin/palettes/frappe.lua",
            "macchiato": "lua/catppuccin/palettes/macchiato.lua",
            "mocha": "lua/catppuccin/palettes/mocha.lua",
        }
        return (
            {
                variant: parse_lua_assignments((root / path).read_text())
                for variant, path in files.items()
            },
            list(files.values()),
        )

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
    lua_rel = "lua/dracula/palette.lua"
    if (root / lua_rel).exists():
        return {"default": parse_lua_assignments((root / lua_rel).read_text())}, [lua_rel]

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
    if not (root / rel).exists():
        rel = "lua/nordic/palette.lua"
        return {"default": parse_lua_assignments((root / rel).read_text())}, [rel]

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
    variants = colorscheme_meta[colorscheme]
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


def build_source(colorscheme: str, colorscheme_meta: dict[str, Any]) -> dict[str, Any]:
    upstream: dict[str, dict[str, str]] = {}
    parsed_paths: list[str] = []

    if colorscheme in PARSERS:
        upstream, parsed_paths = PARSERS[colorscheme](source_path(colorscheme))

    previous_palettes = load_previous_variants(colorscheme, "palette")
    variants = {}
    for variant in variant_names(colorscheme, colorscheme_meta):
        variants[variant] = {
            "palette": upstream.get(variant, previous_palettes.get(variant, {}))
        }

    return {
        "schema": 1,
        "colorscheme": colorscheme,
        "source": source_info(colorscheme, parsed_paths),
        "generated": {
            "tool": "scripts/update-sources.py",
            "note": "palette is parsed from official source files when available.",
        },
        "variants": variants,
    }


def main() -> int:
    SOURCES.mkdir(exist_ok=True)
    colorschemes = sorted(path.stem for path in SOURCES.glob("*.json"))
    colorscheme_meta = {
        colorscheme: list(
            json.loads((SOURCES / f"{colorscheme}.json").read_text())["variants"].keys()
        )
        for colorscheme in colorschemes
    }

    for colorscheme in colorschemes:
        source = build_source(colorscheme, colorscheme_meta)
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
