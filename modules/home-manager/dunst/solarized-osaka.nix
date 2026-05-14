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
  target = "dunst";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."dunst/dunstrc.d/${cfg.${target}.prefix}-solarized-osaka.conf".source =
      "${source}/extras/dunst/${slug}.dunstrc";
  };
}
