{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  source = pkgs.nixporn.kanagawa;
  target = "hyprland";
  enable =
    cfg.enable
    && cfg.colorscheme == "kanagawa"
    && cfg.${target}.enable
    && cfg.colorschemes.kanagawa.variant == "wave";
in
{
  config = lib.mkIf enable {
    wayland.windowManager.hyprland.settings.source = [ "${source}/extras/hyprland/kanagawa-wave.conf" ];
  };
}
