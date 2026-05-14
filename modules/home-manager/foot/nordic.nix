{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.nordic.palette) ansi;
  target = "foot";
  enable = cfg.enable && cfg.colorscheme == "nordic" && cfg.${target}.enable;
  color = lib.removePrefix "#";
in
{
  config = lib.mkIf enable {
    programs.foot.settings.colors = {
      background = color ansi.bg;
      foreground = color ansi.fg;
      regular0 = color ansi.black;
      regular1 = color ansi.red;
      regular2 = color ansi.green;
      regular3 = color ansi.yellow;
      regular4 = color ansi.blue;
      regular5 = color ansi.magenta;
      regular6 = color ansi.cyan;
      regular7 = color ansi.white;
      bright0 = color ansi.bright_black;
      bright1 = color ansi.bright_red;
      bright2 = color ansi.bright_green;
      bright3 = color ansi.bright_yellow;
      bright4 = color ansi.bright_blue;
      bright5 = color ansi.bright_magenta;
      bright6 = color ansi.bright_cyan;
      bright7 = color ansi.bright_white;
    };
  };
}
