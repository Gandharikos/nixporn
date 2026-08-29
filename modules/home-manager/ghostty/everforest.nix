{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.everforest) slug;
  source = pkgs.nixporn.everforest.ghostty;
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.ghostty.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${slug}".source = "${source}/${slug}.ghostty";
    programs.ghostty.settings.theme = "light:${slug},dark:${slug}";
  };
}
