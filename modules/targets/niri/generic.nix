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
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "niri" && isLinux) {
    programs.niri.settings.layout = mkIf (config.programs.niri.enable or false) (
      with colors;
      {
        background-color = bg;
        border = {
          active.color = magenta;
          inactive.color = bg_highlight;
          urgent.color = red;
        };
        focus-ring = {
          active.gradient = {
            from = blue;
            to = magenta;
            angle = 45;
            in' = "oklch longer hue";
          };
          inactive.color = bg_dark;
          urgent.color = yellow;
        };
      }
    );
  };
}
