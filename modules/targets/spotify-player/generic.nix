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
  config = mkIf (targetEnabled "spotify-player") {
    programs.spotify-player = mkIf (config.programs.spotify-player.enable or false) {
      settings.theme = slug;
      themes = [
        {
          name = slug;
          palette = with colors; {
            background = bg;
            foreground = fg;
            inherit
              black
              red
              green
              yellow
              blue
              magenta
              cyan
              white
              bright_black
              bright_red
              bright_green
              bright_yellow
              bright_blue
              bright_magenta
              bright_cyan
              bright_white
              ;
          };
        }
      ];
    };
  };
}
