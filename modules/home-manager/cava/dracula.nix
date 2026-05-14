{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "cava";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."cava/themes/dracula".source = "${sources.cava}/dracula.cava";
    programs.cava.settings.color.theme = "dracula";
  };
}
