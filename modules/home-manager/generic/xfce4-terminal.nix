{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "xfce4-terminal";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.xfconf.settings.xfce4-terminal = {
        color-background = ansi.bg;
        color-foreground = ansi.fg;
        color-cursor = ansi.fg;
        color-palette = lib.concatStringsSep ";" [
          ansi.black
          ansi.red
          ansi.green
          ansi.yellow
          ansi.blue
          ansi.magenta
          ansi.cyan
          ansi.white
          ansi.bright_black
          ansi.bright_red
          ansi.bright_green
          ansi.bright_yellow
          ansi.bright_blue
          ansi.bright_magenta
          ansi.bright_cyan
          ansi.bright_white
        ];
      };
    }
  );
}
