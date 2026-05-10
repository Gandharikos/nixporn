{ inputs }:
{ config, lib, pkgs, ... }:
let
  nixporn = lib.nixporn or (import ../nixporn { inherit lib; });
  nixpornPackages = import ../packages {
    inherit inputs pkgs;
  };

  sourceDir = name: "${nixpornPackages.${name}}/share/nixporn/${name}/source";
in
{
  imports = [
    ../nixporn/module.nix
  ] ++ builtins.map (
    colorschemeName: import ./home-manager { inherit colorschemeName; }
  ) nixporn.supportedColorschemes;

  config._module.args = {
    inherit nixpornPackages;
    nixpornSources = {
      catppuccin = sourceDir "catppuccin";
      cyberdream = sourceDir "cyberdream";
      decay = sourceDir "decay";
      dracula = sourceDir "dracula";
      gruvbox = sourceDir "gruvbox";
      kanagawa = sourceDir "kanagawa";
      nordic = sourceDir "nordic";
      "rose-pine" = sourceDir "rose-pine";
      "solarized-osaka" = sourceDir "solarized-osaka";
      tokyonight = sourceDir "tokyonight";
      tokyonight-spotify = "${nixpornPackages.tokyonight}/share/nixporn/tokyonight/spotify";
    };
  };
}
