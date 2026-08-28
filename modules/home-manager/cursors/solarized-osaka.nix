{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.palette) ansi;
  cursorPackage = pkgs.nixporn.solarized-osaka.cursors.override {
    cursorThemeName = "XCursor-Pro-Nixporn-solarized-osaka";
    baseColor = ansi.bg;
    outlineColor = ansi.fg;
    watchBackgroundColor = ansi.yellow;
  };
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.cursors.enable;
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = cursorPackage.cursorThemeName;
      package = cursorPackage;
    };

    home.sessionVariables.HYPRCURSOR_THEME = cursorPackage.cursorThemeName;
  };
}
