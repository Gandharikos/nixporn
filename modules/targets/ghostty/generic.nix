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
  config = mkIf (targetEnabled "ghostty") {
    programs.ghostty.settings = mkIf (config.programs.ghostty.enable or false) ({
      background = colors.bg;
      foreground = colors.fg;
      cursor-color = colors.blue;
      selection-background = colors.bg_visual;
      selection-foreground = colors.fg;
      palette = builtins.attrValues (
        lib.mapAttrs' (name: value: {
          name = builtins.substring 5 2 name;
          value = "${builtins.substring 5 2 name}=${value}";
        }) terminalPalette
      );
    });
  };
}
