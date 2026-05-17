{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "xfce4-terminal";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  programEnabled = config.programs."xfce4-terminal".enable or false;
  enable = cfg.enable && cfg.${target}.enable && programEnabled && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    xfconf.settings.xfce4-terminal = {
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
  };
}
