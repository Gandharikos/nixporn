{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "rio";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.rio.settings.colors = {
      background = ansi.bg;
      foreground = ansi.fg;
      black = ansi.black;
      red = ansi.red;
      green = ansi.green;
      yellow = ansi.yellow;
      blue = ansi.blue;
      magenta = ansi.magenta;
      cyan = ansi.cyan;
      white = ansi.white;
      light-black = ansi.bright_black;
      light-red = ansi.bright_red;
      light-green = ansi.bright_green;
      light-yellow = ansi.bright_yellow;
      light-blue = ansi.bright_blue;
      light-magenta = ansi.bright_magenta;
      light-cyan = ansi.bright_cyan;
      light-white = ansi.bright_white;
    };
  };
}
