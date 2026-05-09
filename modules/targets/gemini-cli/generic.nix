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
  config = mkIf (targetEnabled "gemini-cli") {
    programs."gemini-cli".settings.ui = mkIf (config.programs."gemini-cli".enable or false) {
      theme = slug;
      customThemes.${slug} = with colors; {
        type = "custom";
        name = slug;
        Background = bg;
        Foreground = fg;
        LightBlue = blue;
        AccentBlue = blue;
        AccentPurple = magenta;
        AccentCyan = cyan;
        AccentGreen = green;
        AccentYellow = yellow;
        AccentRed = red;
        DiffAdded = green;
        DiffRemoved = red;
        Comment = comment;
        Gray = fg_dark;
      };
    };
  };
}
