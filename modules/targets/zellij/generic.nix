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
  config = mkIf (targetEnabled "zellij") {
    programs.zellij = mkIf (config.programs.zellij.enable or false) {
      settings = {
        theme = slug;
        theme_dir = "${config.xdg.configHome}/zellij/themes";
      };
      themes.${slug}.themes.${slug} = with colors; {
        inherit
          blue
          cyan
          fg
          green
          magenta
          orange
          red
          white
          yellow
          ;
        bg = bg_highlight;
        black = bg;
      };
    };
  };
}
