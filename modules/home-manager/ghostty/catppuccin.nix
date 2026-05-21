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
  target = "ghostty";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}";
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${themeName}".source = "${sources.ghostty}/themes/${themeName}.conf";
    programs.ghostty.settings.theme = "light:${themeName},dark:${themeName}";
  };
}
