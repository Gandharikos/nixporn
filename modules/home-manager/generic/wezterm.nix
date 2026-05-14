{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "wezterm";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.wezterm.extraConfig = ''
        config.colors = {
          foreground = "${ansi.fg}",
          background = "${ansi.bg}",
          ansi = { "${ansi.black}", "${ansi.red}", "${ansi.green}", "${ansi.yellow}", "${ansi.blue}", "${ansi.magenta}", "${ansi.cyan}", "${ansi.white}" },
          brights = { "${ansi.bright_black}", "${ansi.bright_red}", "${ansi.bright_green}", "${ansi.bright_yellow}", "${ansi.bright_blue}", "${ansi.bright_magenta}", "${ansi.bright_cyan}", "${ansi.bright_white}" },
        }
      '';
    }
  );
}
