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
    home.pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
    };
  };
}
