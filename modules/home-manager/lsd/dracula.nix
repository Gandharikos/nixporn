{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "lsd";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."lsd/colors.yaml".source = "${sources.lsd}/colors.yaml";
    programs.lsd.settings.color.theme = "custom";
  };
}
