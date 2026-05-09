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
  config = mkIf (targetEnabled "starship") {
    programs.starship.settings = mkIf (config.programs.starship.enable or false) (
      with colors;
      {
        palette = slug;
        palettes.${slug} = {
          inherit
            bg
            fg
            red
            green
            yellow
            blue
            magenta
            cyan
            white
            ;
          gray = bg_highlight;
        };
      }
    );
  };
}
