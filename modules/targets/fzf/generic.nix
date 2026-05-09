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
  config = mkIf (targetEnabled "fzf") {
    programs.fzf.colors = with colors; {
      "bg+" = bg_visual;
      "bg" = bg_dark;
      "border" = border_highlight;
      "fg" = fg;
      "gutter" = bg_dark;
      "header" = orange;
      "hl+" = blue;
      "hl" = blue;
      "info" = comment;
      "marker" = magenta;
      "pointer" = magenta;
      "prompt" = blue;
      "query" = fg;
      "scrollbar" = border_highlight;
      "separator" = orange;
      "spinner" = magenta;
    };
  };
}
