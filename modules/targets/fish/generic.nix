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
  config = mkIf (targetEnabled "fish") {
    programs.fish.interactiveShellInit = mkIf (config.programs.fish.enable or false) (
      with colors;
      ''
        set -g fish_color_normal ${strip fg}
        set -g fish_color_command ${strip blue}
        set -g fish_color_keyword ${strip magenta}
        set -g fish_color_quote ${strip green}
        set -g fish_color_redirection ${strip cyan}
        set -g fish_color_end ${strip orange}
        set -g fish_color_error ${strip red}
        set -g fish_color_param ${strip fg}
        set -g fish_color_comment ${strip comment}
        set -g fish_color_selection --background=${strip bg_visual}
        set -g fish_color_search_match --background=${strip bg_highlight}
        set -g fish_color_operator ${strip cyan}
        set -g fish_color_escape ${strip magenta}
        set -g fish_color_autosuggestion ${strip comment}
      ''
    );
  };
}
