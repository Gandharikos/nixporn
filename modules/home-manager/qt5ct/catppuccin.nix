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
  target = "qt5ct";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable && config.qt.enable;
in
{
  config = lib.mkIf enable {
    qt = lib.genAttrs [ "qt5ctSettings" "qt6ctSettings" ] (_: {
      Appearance = {
        custom_palette = true;
        color_scheme_path = "${sources.qt5ct}/catppuccin-${flavor}-${accent}.conf";
      };
    });
  };
}
