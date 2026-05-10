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
  config = mkIf (targetEnabled "bat") {
    programs.bat = {
      config.theme = mkDefault slug;
      themes.${slug} = {
        src = pkgs.writeTextDir "${slug}.tmColorscheme" tmColorscheme;
        file = "${slug}.tmColorscheme";
      };
    };
  };
}
