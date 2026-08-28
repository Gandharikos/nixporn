from pathlib import Path
from shutil import copy2
from sys import argv

import tomli
import tomli_w


def cursor_value(settings, fallback, key):
    return settings.get(key, fallback.get(key))


config_path = Path(argv[1])
bitmap_source = Path(argv[2])
output = Path(argv[3])
canvas_size = int(argv[4])

with config_path.open("rb") as file:
    cursors = tomli.load(file)["cursors"]

fallback = cursors["fallback_settings"]

for name, settings in cursors.items():
    if name == "fallback_settings":
        continue

    static_image = bitmap_source / f"{name}.png"
    animated_images = sorted(bitmap_source.glob(f"{name}-*.png"))
    images = [static_image] if static_image.exists() else animated_images

    if not images:
        raise FileNotFoundError(f"missing bitmap source for {name}")

    cursor_output = output / name
    cursor_output.mkdir(parents=True)

    delay = cursor_value(settings, fallback, "x11_delay")
    define_size = []
    for image in images:
        copy2(image, cursor_output / image.name)
        fields = ["0", image.name]
        if len(images) > 1:
            fields.append(str(delay))
        define_size.append(",".join(fields))

    general = {
        "define_size": ";".join(define_size),
        "hotspot_x": cursor_value(settings, fallback, "x_hotspot") / canvas_size,
        "hotspot_y": cursor_value(settings, fallback, "y_hotspot") / canvas_size,
    }

    overrides = settings.get("x11_symlinks", [])
    if overrides:
        general["define_override"] = ";".join(overrides)

    with (cursor_output / "meta.toml").open("wb") as file:
        tomli_w.dump({"General": general}, file)
