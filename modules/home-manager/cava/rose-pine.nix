{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) variant;
  sources = pkgs.nixporn.rose-pine;
  target = "cava";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  themeFile = if variant == "main" then "rosepine" else variant;
in
{
  config = lib.mkIf enable {
    xdg.configFile."cava/themes/rose-pine".source = "${sources.cava}/${themeFile}";
    programs.cava.settings.color.theme = "rose-pine";
  };
}
