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
  config = mkIf (targetEnabled "yazi") {
    programs.yazi.theme = mkIf (config.programs.yazi.enable or false) {
      manager = with colors; {
        cwd = {
          fg = blue;
        };
        hovered = {
          fg = bg;
          bg = blue;
        };
        preview_hovered = {
          underline = true;
        };
        border_symbol = " ";
        border_style.fg = bg_highlight;
      };
      status = with colors; {
        separator_open = "";
        separator_close = "";
        mode_normal = {
          fg = bg;
          bg = blue;
          bold = true;
        };
        mode_select = {
          fg = bg;
          bg = magenta;
          bold = true;
        };
        mode_unset = {
          fg = bg;
          bg = red;
          bold = true;
        };
      };
    };
  };
}
