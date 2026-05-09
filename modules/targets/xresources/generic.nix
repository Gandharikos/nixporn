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
  config = mkIf (targetEnabled "xresources" && isLinux) {
    xresources.properties = with colors; {
      "*foreground" = fg;
      "*background" = bg;
      "*cursorColor" = blue;
      "*color0" = black;
      "*color1" = red;
      "*color2" = green;
      "*color3" = yellow;
      "*color4" = blue;
      "*color5" = magenta;
      "*color6" = cyan;
      "*color7" = white;
      "*color8" = bright_black;
      "*color9" = bright_red;
      "*color10" = bright_green;
      "*color11" = bright_yellow;
      "*color12" = bright_blue;
      "*color13" = bright_magenta;
      "*color14" = bright_cyan;
      "*color15" = bright_white;
    };
  };
}
