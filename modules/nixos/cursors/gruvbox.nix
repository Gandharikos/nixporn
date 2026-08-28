{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.palette) ansi;
  cursorPackage = pkgs.nixporn.gruvbox.cursors.override {
    cursorThemeName = "GoogleDot-Nixporn-gruvbox";
    baseColor = ansi.bg;
    outlineColor = ansi.fg;
  };
  enable = cfg.enable && cfg.colorscheme == "gruvbox" && cfg.cursors.enable;
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
