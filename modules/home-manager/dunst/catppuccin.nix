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
  target = "dunst";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."dunst/dunstrc.d/${cfg.${target}.prefix}-catppuccin.conf".source =
      "${sources.dunst}/${flavor}.conf";
  };
}
