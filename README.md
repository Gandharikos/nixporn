# nixporn

A minimal Nix colorscheme module.

## Outputs

- `nixosModules.colorscheme`
- `homeModules.colorscheme`
- `darwinModules.colorscheme`
- `overlays.default`

## Packages

Upstream target sources are exposed through `overlays.default` as
`pkgs.nixporn.<colorscheme>.<target>`. Catppuccin sources are pinned in
`pkgs/catppuccin/sources.json`.

## Options

- `nixporn.enable`
- `nixporn.colorscheme`
- `nixporn.wallpaper`
- `nixporn.avatar`
- `nixporn.palette`
- `nixporn.<target>.enable`
- `nixporn.colorschemes.<colorscheme>.targets.<target>`
- `nixporn.colorschemes.<colorscheme>.slug`
- `nixporn.colorschemes.<colorscheme>.palette`

`nixporn.colorscheme` is an enum generated from `sources/*.json` and defaults to
`catppuccin`. When `nixporn.enable = true`, known target entries default to
enabled. Target values can still be overridden per target.

Target names are generated from directories in `modules/home-manager` and
`modules/nixos`. Each target directory has a `default.nix` that imports the other
`.nix` files in that target directory, so target-specific options can live there.
Catppuccin target support is provided by `catppuccin.nix` in each target
directory, but Catppuccin options stay under `nixporn.colorschemes.catppuccin`.

Each `nixporn.colorschemes.<colorscheme>` has its own options. For example,
Catppuccin has `flavor` and `accent`, Tokyo Night has `style`, and most other
colorschemes have `variant`. `targets` is generated from upstream target
metadata when that colorscheme provides it.

`nixporn.avatar` and `nixporn.wallpaper` are top-level resources. They are not
colorscheme-specific options.

## Example

```nix
{
  imports = [ inputs.nixporn.homeModules.colorscheme ];

  nixporn = {
    enable = true;
    colorscheme = "catppuccin";

    kitty.enable = false;

    colorschemes.catppuccin = {
      flavor = "mocha";
      accent = "mauve";
    };
  };
}
```
