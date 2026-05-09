{ lib }:
let
  common = import ./common.nix { inherit lib; };
  args = {
    inherit common lib;
  };
in
{
  catppuccin = import ./catppuccin.nix args;
  cyberdream = import ./cyberdream.nix args;
  decay = import ./decay.nix args;
  dracula = import ./dracula.nix args;
  gruvbox = import ./gruvbox.nix args;
  kanagawa = import ./kanagawa.nix args;
  nordic = import ./nordic.nix args;
  "rose-pine" = import ./rose-pine.nix args;
  "solarized-osaka" = import ./solarized-osaka.nix args;
  tokyonight = import ./tokyonight.nix args;
}
