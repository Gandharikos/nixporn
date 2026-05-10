{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ../common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    gradient
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    rgba
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "hyprland" && isLinux) {
    wayland.windowManager.hyprland.settings =
      mkIf (config.wayland.windowManager.hyprland.enable or false)
        (
          with colors;
          {
            general = {
              "col.inactive_border" = gradient bg_highlight 0.5 bg_dark 0.9 45;
              "col.active_border" = gradient border_highlight 0.4 magenta 0.9 45;
            };
            decoration.shadow = {
              color = rgba bg_highlight 0.7;
              color_inactive = rgba black 0.9;
            };
          }
        );
  };
}
