{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "ghostty";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${slug}".source = "${source}/extras/ghostty/${slug}";
    programs.ghostty.settings.theme = "light:${slug},dark:${slug}";
  };
}
