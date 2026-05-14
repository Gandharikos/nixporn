{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "ghostty";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${slug}".source = "${sources.ghostty}/dist/${slug}";
    programs.ghostty.settings.theme = "light:${slug},dark:${slug}";
  };
}
