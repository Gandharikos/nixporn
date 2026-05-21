{
  moduleLib ? null,
  moduleType ? null,
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  lib' =
    if moduleLib != null then
      moduleLib
    else
      lib.extend (
        final: _: {
          nixporn = import ../lib { lib = final; };
        }
      );

  inherit (lib') genAttrs;

  cfg = config.nixporn;
  colorschemes = import ./colorschemes { lib = lib'; };

  targetDirectory =
    if moduleType == "home" then
      ./home-manager
    else if moduleType == "nixos" then
      ./nixos
    else
      null;

  targetModule =
    if targetDirectory == null || !(builtins.pathExists targetDirectory) then
      [ ]
    else
      [ (import targetDirectory { lib = lib'; }) ];
in
{
  imports = targetModule;

  options.nixporn = import ./options.nix {
    inherit
      cfg
      colorschemes
      pkgs
      ;
    lib = lib';
  };

  config.nixporn = {
    palette = cfg.colorschemes.${cfg.colorscheme}.palette;

    colorschemes = genAttrs colorschemes.colorschemeNames (
      name: colorschemes.mkColorschemeConfig name cfg.colorschemes.${name}
    );
  };
}
