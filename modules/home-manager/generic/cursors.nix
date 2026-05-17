{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "cursors";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.${target}) bibata;
  cursorName = "Bibata-Nixporn-${colorscheme}";
  hyprcursorName = "${cursorName}-Hyprcursor";
  cursorPackage = pkgs.nixporn.bibata.xcursor.override {
    cursorThemeName = cursorName;
    inherit (bibata)
      baseColor
      outlineColor
      watchBackgroundColor
      ;
  };
  hyprcursorPackage = pkgs.nixporn.bibata.hyprcursor.override {
    cursorThemeName = hyprcursorName;
    colorName = colorscheme;
    inherit (bibata)
      baseColor
      outlineColor
      watchBackgroundColor
      ;
  };
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = lib.mkDefault cursorName;
      package = lib.mkDefault cursorPackage;
    };

    home.packages = [ hyprcursorPackage ];
    home.sessionVariables.HYPRCURSOR_THEME = lib.mkDefault hyprcursorName;
  };
}
