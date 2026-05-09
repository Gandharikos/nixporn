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
  config = mkIf (targetEnabled "dunst") {
    services.dunst.settings = mkIf (config.services.dunst.enable or false) {
      global = with colors; {
        frame_color = mkDefault blue;
        separator_color = mkDefault bg_highlight;
        highlight = mkDefault blue;
      };
      urgency_low = with colors; {
        background = mkDefault bg;
        foreground = mkDefault fg;
      };
      urgency_normal = with colors; {
        background = mkDefault bg;
        foreground = mkDefault fg;
      };
      urgency_critical = with colors; {
        background = mkDefault bg;
        foreground = mkDefault red;
        frame_color = mkDefault red;
      };
    };
  };
}
