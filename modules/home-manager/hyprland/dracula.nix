{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "hyprland";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    wayland.windowManager.hyprland.settings.source = [
      "${sources.hyprland}/dracula_colors.conf"
    ];
  };
}
