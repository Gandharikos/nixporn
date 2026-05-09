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
  config = mkIf (targetEnabled "delta") {
    programs.delta.options.features = mkDefault slug;
    programs.git.includes = mkIf (config.programs.delta.enable or false) [
      {
        path = pkgs.writeText "delta-${slug}.gitconfig" (
          with colors;
          ''
            [delta "${slug}"]
              dark = ${if isLight then "false" else "true"}
              file-style = ${fg}
              hunk-header-style = syntax ${blue}
              minus-style = syntax ${red}
              plus-style = syntax ${green}
              zero-style = syntax ${fg_dark}
          ''
        );
      }
    ];
  };
}
