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
  config = mkIf (targetEnabled "kitty") {
    programs.kitty.settings = mkIf (config.programs.kitty.enable or false) (
      with colors;
      terminalPalette
      // {
        foreground = fg;
        background = bg;
        selection_foreground = fg;
        selection_background = bg_visual;
        cursor = blue;
        url_color = cyan;
        active_border_color = blue;
        inactive_border_color = bg_highlight;
      }
    );
  };
}
