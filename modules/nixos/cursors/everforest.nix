{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  polarity = cfg.colorschemes.everforest.polarity;
  cursorColor = if cfg.cursors.accent == "auto" then polarity else cfg.cursors.accent;
  cursorName = "everforest-cursors${lib.optionalString (cursorColor == "light") "-light"}";
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.cursors.enable;
in
{
  config = lib.mkIf enable {
    environment.systemPackages = [ pkgs.nixporn.everforest.cursors ];
    environment.variables.XCURSOR_THEME = cursorName;
  };
}
