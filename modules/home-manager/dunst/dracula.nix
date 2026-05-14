{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "dunst";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."dunst/dunstrc.d/${cfg.${target}.prefix}-dracula.conf".source =
      "${sources.dunst}/dunstrc";
  };
}
