#!/usr/bin/env python3
"""Update pinned palette and target sources to their latest upstream revisions."""

from __future__ import annotations

import asyncio
import json
import os
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from multiprocessing import cpu_count
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "sources"
TARGET_SOURCE_FILES = {
    "extra": ROOT / "pkgs/extra-sources.json",
    "cursors": ROOT / "pkgs/cursor-sources.json",
    "catppuccin": ROOT / "pkgs/catppuccin/sources.json",
    "decay": ROOT / "pkgs/decay/sources.json",
    "dracula": ROOT / "pkgs/dracula/sources.json",
    "everforest": ROOT / "pkgs/everforest/sources.json",
    "rose-pine": ROOT / "pkgs/rose-pine/sources.json",
}
TARGET_REFS = {
    ("catppuccin", "discord"): "gh-pages",
}


@dataclass(frozen=True)
class Pin:
    path: Path
    key: str
    ref: str
    hash_field: str


def github_ref(url: str, ref: str | None = None) -> str:
    if not url.startswith("github:"):
        raise ValueError(f"unsupported source URL: {url}")
    return f"{url}/{ref}" if ref else url


def load_documents() -> dict[Path, dict[str, Any]]:
    paths = [*sorted(SOURCES.glob("*.json")), *TARGET_SOURCE_FILES.values()]
    return {path: json.loads(path.read_text()) for path in paths}


def collect_pins(documents: dict[Path, dict[str, Any]]) -> list[Pin]:
    pins = []

    for path in sorted(SOURCES.glob("*.json")):
        source = documents[path]["source"]
        pins.append(
            Pin(
                path=path,
                key="source",
                ref=github_ref(source["url"]),
                hash_field="narHash",
            )
        )

    for family, path in TARGET_SOURCE_FILES.items():
        for target, source in documents[path].items():
            if family == "catppuccin":
                url = f"github:catppuccin/{target}"
            else:
                url = source["url"]
            pins.append(
                Pin(
                    path=path,
                    key=target,
                    ref=github_ref(url, TARGET_REFS.get((family, target))),
                    hash_field="hash" if "hash" in source else "narHash",
                )
            )

    return pins


def nix_environment() -> dict[str, str]:
    environment = os.environ.copy()
    token = environment.get("GITHUB_TOKEN")
    if not token:
        try:
            result = subprocess.run(
                ["gh", "auth", "token"],
                check=False,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
            )
            if result.returncode == 0:
                token = result.stdout.strip()
        except FileNotFoundError:
            pass

    if token:
        nix_config = environment.get("NIX_CONFIG", "").rstrip()
        environment["NIX_CONFIG"] = (
            f"{nix_config}\n" if nix_config else ""
        ) + f"access-tokens = github.com={token}"

    return environment


async def prefetch(
    ref: str,
    semaphore: asyncio.Semaphore,
    environment: dict[str, str],
) -> dict[str, Any]:
    async with semaphore:
        print(f"fetching {ref}")
        process = await asyncio.create_subprocess_exec(
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "flake",
            "prefetch",
            "--json",
            ref,
            cwd=ROOT,
            env=environment,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await process.communicate()
        if process.returncode != 0:
            message = stderr.decode().strip() or f"failed to fetch {ref}"
            raise subprocess.CalledProcessError(process.returncode, ref, stderr=message)
        return json.loads(stdout)


async def fetch_all(refs: set[str]) -> dict[str, dict[str, Any]]:
    semaphore = asyncio.Semaphore(min(8, cpu_count()))
    environment = nix_environment()
    results = await asyncio.gather(
        *(prefetch(ref, semaphore, environment) for ref in sorted(refs))
    )
    return dict(zip(sorted(refs), results, strict=True))


def update_documents(
    documents: dict[Path, dict[str, Any]],
    pins: list[Pin],
    fetched: dict[str, dict[str, Any]],
) -> int:
    changed = 0

    for pin in pins:
        source = documents[pin.path][pin.key]
        result = fetched[pin.ref]
        locked = result["locked"]
        updated = source | {
            "rev": locked["rev"],
            pin.hash_field: result["hash"] if "hash" in result else locked["narHash"],
        }
        if "lastModified" in source:
            updated["lastModified"] = datetime.fromtimestamp(
                int(locked["lastModified"]),
                tz=timezone.utc,
            ).strftime("%Y-%m-%d")

        if updated != source:
            documents[pin.path][pin.key] = updated
            changed += 1

    return changed


def write_documents(documents: dict[Path, dict[str, Any]]) -> None:
    for path, document in documents.items():
        rendered = json.dumps(document, indent=2, sort_keys=True) + "\n"
        if rendered != path.read_text():
            path.write_text(rendered)
            print(f"updated {path.relative_to(ROOT)}")


async def main() -> int:
    documents = load_documents()
    pins = collect_pins(documents)
    fetched = await fetch_all({pin.ref for pin in pins})
    changed = update_documents(documents, pins, fetched)
    write_documents(documents)
    print(f"updated {changed} of {len(pins)} pins")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(asyncio.run(main()))
    except subprocess.CalledProcessError as error:
        sys.stderr.write(f"{error.stderr}\n")
        raise SystemExit(error.returncode)
