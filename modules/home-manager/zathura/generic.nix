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
  config = mkIf (targetEnabled "zathura") {
    programs.zathura.options = mkIf (config.programs.zathura.enable or false) (
      with colors;
      {
        default-bg = bg;
        default-fg = fg;
        statusbar-bg = bg_dark;
        statusbar-fg = fg;
        inputbar-bg = bg_dark;
        inputbar-fg = fg;
        notification-bg = bg_dark;
        notification-fg = fg;
        notification-error-bg = bg_dark;
        notification-error-fg = red;
        notification-warning-bg = bg_dark;
        notification-warning-fg = yellow;
        highlight-color = yellow;
        highlight-active-color = orange;
        completion-bg = bg_dark;
        completion-fg = fg;
        completion-highlight-bg = bg_highlight;
        completion-highlight-fg = fg;
        recolor-lightcolor = bg;
        recolor-darkcolor = fg;
      }
    );
  };
}
