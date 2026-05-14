{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "cava";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  inherit (cfg.${target}) transparent;
  themeFile = "${flavor}" + lib.optionalString transparent "-transparent" + ".cava";
in
{
  config = lib.mkIf enable {
    xdg.configFile."cava/themes/catppuccin".source = "${sources.cava}/${themeFile}";
    programs.cava.settings.color.theme = "catppuccin";
  };
}
