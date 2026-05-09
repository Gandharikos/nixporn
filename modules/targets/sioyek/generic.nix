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
  config = mkIf (targetEnabled "sioyek") {
    programs.sioyek.config = mkIf (config.programs.sioyek.enable or false) (
      with colors;
      {
        background_color = hexToRgb bg;
        text_highlight_color = hexToRgb yellow;
        visual_mark_color = hexToRgba comment 0.2;
        search_highlight_color = hexToRgb yellow;
        link_highlight_color = hexToRgb blue;
        synctex_highlight_color = hexToRgb green;
        highlight_color_a = hexToRgb yellow;
        highlight_color_b = hexToRgb green;
        highlight_color_c = hexToRgb cyan;
        highlight_color_d = hexToRgb red;
        highlight_color_e = hexToRgb magenta;
        highlight_color_f = hexToRgb orange;
        highlight_color_g = hexToRgb blue;
        custom_background_color = hexToRgb bg;
        custom_text_color = hexToRgb fg;
        ui_text_color = hexToRgb fg;
        ui_background_color = hexToRgb bg_highlight;
        ui_selected_text_color = hexToRgb fg;
        ui_selected_background_color = hexToRgb bg_visual;
        status_bar_color = hexToRgb bg_highlight;
        status_bar_text_color = hexToRgb fg;
        page_separator_color = hexToRgb bg_highlight;
        default_dark_mode = if isLight then "0" else "1";
      }
    );
  };
}
