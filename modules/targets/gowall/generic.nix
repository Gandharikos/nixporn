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
  config = mkIf (targetEnabled "gowall") {
    home.packages = [ pkgs.gowall ];
    home.file.".config/gowall/config.yml".text = with colors; ''
      themes:
        - name: "${slug}"
          colors:
            - "${black}"
            - "${bright_black}"
            - "${red}"
            - "${bright_red}"
            - "${green}"
            - "${bright_green}"
            - "${yellow}"
            - "${bright_yellow}"
            - "${blue}"
            - "${bright_blue}"
            - "${magenta}"
            - "${bright_magenta}"
            - "${cyan}"
            - "${bright_cyan}"
            - "${white}"
            - "${bright_white}"
    '';
  };
}
