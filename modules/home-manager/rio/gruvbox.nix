{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.gruvbox.palette) ansi;
  target = "rio";
  enable = cfg.enable && cfg.colorscheme == "gruvbox" && cfg.${target}.enable;
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
