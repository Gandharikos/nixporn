{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "limine";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    boot.loader.limine = {
      extraConfig = lib.fileContents "${sources.limine}/catppuccin-${flavor}.conf";
      style.wallpapers = [ ];
    };
  };
}
