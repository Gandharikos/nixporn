{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "zellij";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
  theme = {
    text_unselected = {
      base = ansi.fg;
      background = ansi.black;
      emphasis_0 = ansi.yellow;
      emphasis_1 = ansi.cyan;
      emphasis_2 = ansi.green;
      emphasis_3 = ansi.magenta;
    };
    text_selected = {
      base = ansi.fg;
      background = ansi.bright_black;
      emphasis_0 = ansi.yellow;
      emphasis_1 = ansi.cyan;
      emphasis_2 = ansi.green;
      emphasis_3 = ansi.magenta;
    };
    ribbon_selected = {
      base = ansi.black;
      background = ansi.magenta;
      emphasis_0 = ansi.red;
      emphasis_1 = ansi.yellow;
      emphasis_2 = ansi.magenta;
      emphasis_3 = ansi.blue;
    };
    ribbon_unselected = {
      base = ansi.fg;
      background = ansi.black;
      emphasis_0 = ansi.red;
      emphasis_1 = ansi.fg;
      emphasis_2 = ansi.blue;
      emphasis_3 = ansi.magenta;
    };
    frame_selected = {
      base = ansi.magenta;
      background = ansi.bg;
      emphasis_0 = ansi.yellow;
      emphasis_1 = ansi.cyan;
      emphasis_2 = ansi.magenta;
      emphasis_3 = ansi.bg;
    };
    frame_highlight = {
      base = ansi.red;
      background = ansi.bg;
      emphasis_0 = ansi.magenta;
      emphasis_1 = ansi.yellow;
      emphasis_2 = ansi.yellow;
      emphasis_3 = ansi.yellow;
    };
    exit_code_success = {
      base = ansi.green;
      background = ansi.bg;
      emphasis_0 = ansi.cyan;
      emphasis_1 = ansi.black;
      emphasis_2 = ansi.magenta;
      emphasis_3 = ansi.blue;
    };
    exit_code_error = {
      base = ansi.red;
      background = ansi.bg;
      emphasis_0 = ansi.yellow;
      emphasis_1 = ansi.bg;
      emphasis_2 = ansi.bg;
      emphasis_3 = ansi.bg;
    };
  };
in
{
  config = lib.mkIf enable {
    programs.zellij = {
      settings.theme = themeName;
      themes.${themeName}.themes.default = theme;
    };
  };
}
