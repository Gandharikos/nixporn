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
  config = mkIf (targetEnabled "dank-material-shell") {
    programs.dank-material-shell.settings = mkIf (config.programs.dank-material-shell.enable or false) {
      currentThemeName = "custom";
      customThemeFile = pkgs.writeText "dank-material-shell-${slug}.json" (
        builtins.toJSON {
          dark = materialColors;
          light = materialColors;
        }
      );
    };
  };
}
