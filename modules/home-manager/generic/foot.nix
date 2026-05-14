{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "foot";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.foot.settings.colors = {
        background = hex ansi.bg;
        foreground = hex ansi.fg;
        regular0 = hex ansi.black;
        regular1 = hex ansi.red;
        regular2 = hex ansi.green;
        regular3 = hex ansi.yellow;
        regular4 = hex ansi.blue;
        regular5 = hex ansi.magenta;
        regular6 = hex ansi.cyan;
        regular7 = hex ansi.white;
        bright0 = hex ansi.bright_black;
        bright1 = hex ansi.bright_red;
        bright2 = hex ansi.bright_green;
        bright3 = hex ansi.bright_yellow;
        bright4 = hex ansi.bright_blue;
        bright5 = hex ansi.bright_magenta;
        bright6 = hex ansi.bright_cyan;
        bright7 = hex ansi.bright_white;
      };
    }
  );
}
