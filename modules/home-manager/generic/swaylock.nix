{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "swaylock";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
  rgba = color: "${hex color}ff";
in
{
  config = lib.mkIf enable {
    programs.swaylock.settings = {
      color = hex ansi.bg;
      inside-color = rgba ansi.bg;
      inside-clear-color = rgba ansi.yellow;
      inside-ver-color = rgba ansi.blue;
      inside-wrong-color = rgba ansi.red;
      key-hl-color = ansi.green;
      bs-hl-color = ansi.red;
      ring-color = rgba ansi.blue;
      ring-clear-color = rgba ansi.yellow;
      ring-ver-color = rgba ansi.blue;
      ring-wrong-color = rgba ansi.red;
      separator-color = "00000000";
      text-color = rgba ansi.fg;
      text-clear-color = rgba ansi.bg;
      text-ver-color = rgba ansi.bg;
      text-wrong-color = rgba ansi.bg;
    };
  };
}
