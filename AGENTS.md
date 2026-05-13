# Repository Guidelines

## Project Structure & Module Organization

This repository is a reusable Nix flake for preset colorscheme modules.
`flake.nix` exposes `nixosModules.colorscheme`, `homeModules.colorscheme`, and
`darwinModules.colorscheme`. It also exposes `packages.${system}` with themed
Bibata cursor packages.

- `nixporn/default.nix` is the schema entry point for colorscheme metadata, palette
  resolution, and public options.
- `nixporn/colorschemes/*.nix` defines colorscheme-specific module options.
- `nixporn/module.nix` defines the base module options, palette resolution, and
  selected colorscheme config.
- `nixporn/palettes.nix` reads normalized palette data from
  `sources/<colorscheme>.json`; `nixporn/presets/*.nix` selects palettes per
  colorscheme.
- `lib/default.nix` contains reusable helpers only, exposed as
  `lib.nixporn.lib`.
- `nixporn/source-repos.nix` pins upstream colorscheme theme configuration
  sources for Home Manager adapters and source regeneration.
- `packages/*.nix` packages generated cursor themes.
- `modules/default.nix` wires Home Manager support and imports the adapter
  set for every supported colorscheme.
- `modules/home-manager/default.nix` imports one directory per Home Manager adapter.
  `modules/home-manager/<target>/default.nix` dispatches to
  `modules/home-manager/<target>/<colorscheme>.nix` when present, otherwise
  `modules/home-manager/<target>/generic.nix`.

Wallpapers, avatars, and host-specific files belong in downstream configurations.
Cursor themes are handled by the Home Manager `cursor` adapter and Bibata fallback
packages.

## Build, Test, and Development Commands

- `nix flake check` validates flake outputs and module evaluation.
- `nix flake show` lists public outputs.
- `python3 scripts/update-sources.py` regenerates `sources/<colorscheme>.json`
  after pinned colorscheme source updates.
- `nix eval --impure --json --expr '(builtins.getFlake (toString ./.)).lib.nixporn.supportedColorschemes'`
  confirms the colorscheme list.

Run commands from the repository root. For adapter changes, also evaluate a
downstream Home Manager config that imports `inputs.nixporn.homeModules.colorscheme`.

## Coding Style & Naming Conventions

Use idiomatic Nix with two-space indentation, trailing semicolons, and clear
`let` bindings for reused values. Prefer helpers from `lib.nixporn.lib` before
adding new abstractions. Use canonical slugs such as `tokyonight`,
`catppuccin`, `rose-pine`, and `solarized-osaka`.

Keep modules declarative and host-agnostic. Do not commit secrets, personal
paths, machine-specific assets, or generated debugging files.

## Testing Guidelines

There is no dedicated test suite yet. Treat Nix evaluation as the baseline:
run `nix flake check` after every change. For new colorscheme or Home Manager adapter behavior,
evaluate at least one consuming Home Manager configuration with
`nixporn.enable = true;` and a relevant `nixporn.colorscheme.name`.

## Commit & Pull Request Guidelines

The visible history only has `Initial commit`, so use Conventional Commits:
`feat: add gruvbox adapter`, `fix: correct rose-pine palette`, or
`docs: update module example`.

Pull requests should describe affected colorschemes and modules, list validation
commands, and mention any downstream configuration used for manual evaluation.
Include screenshots only for visual adapter changes.
