{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  target = "cursors";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  cursorAccent = if cfg.${target}.accent == "auto" then accent else cfg.${target}.accent;
  cursorPackage = pkgs.nixporn.catppuccin.cursors.override {
    accent = cursorAccent;
    inherit flavor;
  };
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = cursorPackage.cursorName;
      package = cursorPackage;
    };
  };
}
