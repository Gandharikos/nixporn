{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) kanagawa;
  inherit (kanagawa) slug;
  source = pkgs.nixporn.kanagawa;
  target = "ghostty";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${slug}".source = "${source}/extras/ghostty/${slug}";
    programs.ghostty.settings.theme = "light:${slug},dark:${slug}";
  };
}
