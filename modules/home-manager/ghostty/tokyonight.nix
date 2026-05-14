{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "ghostty";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${slug}".source = "${source}/extras/ghostty/${slug}";
    programs.ghostty.settings.theme = "light:${slug},dark:${slug}";
  };
}
