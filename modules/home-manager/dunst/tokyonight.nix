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
  target = "dunst";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."dunst/dunstrc.d/${cfg.${target}.prefix}-tokyonight.conf".source =
      "${source}/extras/dunst/${slug}.dunstrc";
  };
}
