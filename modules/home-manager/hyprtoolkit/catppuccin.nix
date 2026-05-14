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
  target = "hyprtoolkit";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."hypr/hyprtoolkit.conf".source =
      "${sources.hyprtoolkit}/${flavor}/catppuccin-${flavor}-${accent}.conf";
  };
}
