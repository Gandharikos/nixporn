{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight.palette) ansi;
  target = "xresources";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xresources.properties = {
      "*foreground" = ansi.fg;
      "*background" = ansi.bg;
      "*cursorColor" = tokyonight.palette.bg_search;
      "*color0" = ansi.black;
      "*color1" = ansi.red;
      "*color2" = ansi.green;
      "*color3" = ansi.yellow;
      "*color4" = ansi.blue;
      "*color5" = ansi.magenta;
      "*color6" = ansi.cyan;
      "*color7" = ansi.white;
      "*color8" = ansi.bright_black;
      "*color9" = ansi.bright_red;
      "*color10" = ansi.bright_green;
      "*color11" = ansi.bright_yellow;
      "*color12" = ansi.bright_blue;
      "*color13" = ansi.bright_magenta;
      "*color14" = ansi.bright_cyan;
      "*color15" = ansi.bright_white;
    };
  };
}
