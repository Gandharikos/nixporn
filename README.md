# nixporn

A reusable Nix colorscheme module collection with presets.

## Modules

- `nixosModules.colorscheme`
- `homeModules.colorscheme`
- `darwinModules.colorscheme`
- `packages.${system}.<colorscheme>`

The public interface is `nixporn.enable` plus `nixporn.colorscheme.*`. Enabling the
module writes the resolved preset palette to `nixporn.colorscheme` and, in Home
Manager, applies colorscheme-specific adapters for supported programs.

## Colorschemes

Current colorschemes:

- Catppuccin
- Cyberdream
- Decay
- Dracula
- Gruvbox
- Kanagawa
- Nordic
- Rose Pine
- Solarized Osaka
- Tokyo Night

These colorschemes are exposed as preset `config.nixporn.colorscheme` attributes.
Wallpaper and avatar paths are exposed as options for downstream modules to
consume; they are not applied by this flake.

## Adapters

Home Manager adapters are exposed through a shared adapter set so each colorscheme has
the same public surface. Tokyo Night uses upstream extras from
`tokyonight.nvim` where they exist. Other colorschemes use palette-derived fallback
adapters until an official or popular upstream port is wired in. Adapter
directories dispatch to `modules/home-manager/<target>/<colorscheme>.nix` when present,
otherwise they use `modules/home-manager/<target>/generic.nix`.

Current Home Manager adapters are `bat`, `btop`, `cursor`, `dank-material-shell`, `delta`, `discord`,
`dunst`, `eza`, `fcitx5`, `fish`, `fzf`, `gemini-cli`, `ghostty`, `gowall`,
`gtk`, `hyprland`, `kitty`, `lazygit`, `niri`, `noctalia-shell`, `opencode`,
`qt`, `sioyek`, `spicetify`, `spotify-player`, `squirrel`, `starship`,
`television`, `tmux`, `wezterm`, `xresources`, `yazi`, `zathura`, and `zellij`.

## Packages

`packages.${system}` contains reusable theme source packages, one per
colorscheme. Each package stores its upstream source under
`share/nixporn/<colorscheme>/source`; Tokyo Night also stores its Spotify theme
source under `share/nixporn/tokyonight/spotify`.

Cursor fallback packages are generated from Bibata for each colorscheme default
variant as `<colorscheme>-xcursor` and `<colorscheme>-hyprcursor`. The Home
Manager `cursor` adapter uses the selected palette to generate matching Bibata
XCursor and Hyprcursor themes.

## Example

```nix
{
  imports = [ inputs.nixporn.homeModules.colorscheme ];

  nixporn = {
    enable = true;
    colorscheme = {
      name = "rose-pine";
      variant = "moon";
    };

    wallpaper = ./wallpaper.png;
    avatar = ./avatar.png;
  };
}
```

## Updating Sources

Colorscheme source metadata and generated palettes live in `sources/<colorscheme>.json`.
Regenerate them after updating the colorscheme source inputs:

```sh
nix flake update catppuccin-palette cyberdream decay dracula gruvbox kanagawa nordic rose-pine solarized-osaka tokyonight tokyonight-spotify
python3 scripts/update-sources.py
nix flake check
```

The scheduled GitHub workflow in `.github/workflows/update-sources.yml` runs
the same update and opens a pull request when sources change.
