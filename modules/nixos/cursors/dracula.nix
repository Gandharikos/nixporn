{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "cursors";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    environment.systemPackages = [ pkgs.dracula-theme ];
    environment.variables.XCURSOR_THEME = "Dracula-cursors";
  };
}
