{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.palette) ansi;
  cursorPackage = pkgs.nixporn.cyberdream.cursors.override {
    cursorThemeName = "XCursor-Pro-Nixporn-cyberdream";
    baseColor = ansi.bg;
    outlineColor = ansi.fg;
    watchBackgroundColor = ansi.red;
  };
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.cursors.enable;
in
{
  config = lib.mkIf enable {
    environment.systemPackages = [ cursorPackage ];
    environment.variables = {
      XCURSOR_THEME = cursorPackage.cursorThemeName;
      HYPRCURSOR_THEME = cursorPackage.cursorThemeName;
    };
  };
}
