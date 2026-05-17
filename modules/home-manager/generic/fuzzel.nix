{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "fuzzel";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
  rgba = color: "${hex color}ff";
in
{
  config = lib.mkIf enable {
    programs.fuzzel.settings.colors = {
      background = rgba ansi.bg;
      text = rgba ansi.fg;
      match = rgba ansi.blue;
      selection = rgba ansi.black;
      selection-text = rgba ansi.bright_white;
      selection-match = rgba ansi.cyan;
      border = rgba ansi.blue;
    };
  };
}
