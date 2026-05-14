# Repository Guidelines

This repository is a minimal Nix colorscheme flake.

## Structure

- `flake.nix` exposes `nixosModules.colorscheme`, `homeModules.colorscheme`,
  and `darwinModules.colorscheme`.
- `module.nix` defines the public `nixporn.*` options.
- `sources/*.json` contains normalized palette data.
- `lib/` contains small reusable helpers.
- `default.nix` and `shell.nix` provide non-flake package and shell entrypoints.

## Commands

- `nix flake check`
- `nix flake show`
- `nixfmt flake.nix module.nix`

Use simple Nix, two-space indentation, and keep the module surface small.
