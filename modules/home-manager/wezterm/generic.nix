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
  config = mkIf (targetEnabled "wezterm") {
    programs.wezterm.extraConfig = mkIf (config.programs.wezterm.enable or false) (
      with colors;
      ''
        config.colors = config.colors or {}
        config.colors.foreground = "${fg}"
        config.colors.background = "${bg}"
        config.colors.cursor_bg = "${blue}"
        config.colors.cursor_fg = "${bg}"
        config.colors.selection_bg = "${bg_visual}"
        config.colors.selection_fg = "${fg}"
        config.colors.ansi = { "${black}", "${red}", "${green}", "${yellow}", "${blue}", "${magenta}", "${cyan}", "${white}" }
        config.colors.brights = { "${bright_black}", "${bright_red}", "${bright_green}", "${bright_yellow}", "${bright_blue}", "${bright_magenta}", "${bright_cyan}", "${bright_white}" }
      ''
    );
  };
}
