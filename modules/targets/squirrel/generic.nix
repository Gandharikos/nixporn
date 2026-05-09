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
  config = mkIf (targetEnabled "squirrel" && isDarwin) {
    home.file."Library/Rime/squirrel.custom.yaml".text = mkIf (config.programs.rime.enable or false) (
      let
        toRimeColor =
          hex: "0x${builtins.substring 5 2 hex}${builtins.substring 3 2 hex}${builtins.substring 1 2 hex}";
      in
      with colors;
      ''
        patch:
          style/color_scheme: ${slug}
          style/color_scheme_dark: ${slug}
          preset_color_schemes/${slug}:
            name: "${slug}"
            author: "nixporn"
            text_color: ${toRimeColor fg}
            back_color: ${toRimeColor bg}
            border_color: ${toRimeColor bg_dark}
            label_color: ${toRimeColor comment}
            candidate_text_color: ${toRimeColor fg}
            comment_text_color: ${toRimeColor comment}
            hilited_text_color: ${toRimeColor bg}
            hilited_back_color: ${toRimeColor blue}
            hilited_candidate_text_color: ${toRimeColor bg}
            hilited_candidate_back_color: ${toRimeColor blue}
      ''
    );
  };
}
