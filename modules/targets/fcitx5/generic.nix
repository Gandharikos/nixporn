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
  config = mkIf (targetEnabled "fcitx5" && isLinux) {
    xdg.configFile."fcitx5/themes/${slug}/theme.conf".text = with colors; ''
      [Metadata]
      Name=${slug}
      Version=0.1
      Author=nixporn
      Description=${slug} fcitx5 theme
      ScaleWithDPI=True

      [InputPanel]
      NormalColor=${fg}
      HighlightCandidateColor=${bg}
      HighlightColor=${blue}
      HighlightBackgroundColor=${bg_highlight}

      [InputPanel/Background]
      Color=${bg}
      BorderColor=${bg_highlight}

      [InputPanel/Highlight]
      Color=${blue}
      BorderColor=${blue}

      [Menu]
      NormalColor=${fg}
      HighlightCandidateColor=${bg}

      [Menu/Background]
      Color=${bg}
      BorderColor=${bg_highlight}

      [Menu/Highlight]
      Color=${blue}
      BorderColor=${blue}
    '';
  };
}
