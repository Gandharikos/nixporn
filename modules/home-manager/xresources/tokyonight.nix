{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (config.nixporn.colorscheme) palette;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."xresources";
  dpi = 96;
  enable = cfg.enable && targetCfg.enable && isLinux;
in
{
  config = mkIf enable {
    xresources.properties = with palette.base; {
      # font
      "*.faceName" = "JetBrainsMono Nerd Font Mono";
      "*.faceSize" = toString 14;
      "*.renderFont" = true;
      # dpi for Xorg.s font
      "Xft.dpi" = dpi;
      # or set a generic dpi
      "*.dpi" = dpi;

      # These might also be useful depending on your monitor and personal preferences.
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintfull";
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
      "*foreground" = fg;
      "*background" = bg;
      "*cursorColor" = bg_search;
      "*color0" = black;
      "*color1" = red;
      "*color2" = green;
      "*color3" = yellow;
      "*color4" = blue;
      "*color5" = magenta;
      "*color6" = cyan;
      "*color7" = fg_dark;
      "*color8" = terminal_black;
      "*color9" = bright_red;
      "*color10" = bright_green;
      "*color11" = bright_yellow;
      "*color12" = bright_blue;
      "*color13" = bright_magenta;
      "*color14" = bright_cyan;
      "*color15" = fg;
    };
  };
}
