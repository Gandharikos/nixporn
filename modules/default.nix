{
  config,
  lib,
  pkgs,
  ...
}:
let
  nixporn = import ../nixporn { inherit lib; };
  nixpornSources = import ../nixporn/source-repos.nix {
    inherit pkgs;
  };
in
{
  imports = [
    ../nixporn/module.nix
  ]
  ++ builtins.map (
    colorschemeName: import ./home-manager { inherit colorschemeName; }
  ) nixporn.supportedColorschemes;

  config._module.args = {
    inherit nixpornSources;
  };
}
