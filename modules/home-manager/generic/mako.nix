{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "mako";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    services.mako.settings = {
      background-color = ansi.bg;
      text-color = ansi.fg;
      border-color = ansi.blue;
      progress-color = "over ${ansi.cyan}";
    };
  };
}
