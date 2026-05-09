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
  config = mkIf (targetEnabled "gtk" && isLinux) {
    gtk = {
      enable = mkDefault true;
      gtk3.extraCss = with colors; ''
        @define-color theme_bg_color ${bg};
        @define-color theme_fg_color ${fg};
        @define-color theme_selected_bg_color ${blue};
        @define-color theme_selected_fg_color ${bg};
        @define-color accent_color ${blue};
      '';
      gtk4.extraCss = with colors; ''
        @define-color window_bg_color ${bg};
        @define-color window_fg_color ${fg};
        @define-color accent_bg_color ${blue};
        @define-color accent_fg_color ${bg};
      '';
    };
  };
}
