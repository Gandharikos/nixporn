{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.nixporn.catppuccin;
  targetCfg = config.nixporn.targets."gtk";
  enable = cfg.enable && targetCfg.enable && isLinux;
  themeName = "catppuccin-${cfg.flavor}-${cfg.accent}-standard";
in
{
  config = mkIf enable {
    gtk = {
      theme = {
        name = themeName;
        package = pkgs.catppuccin-gtk.override {
          accents = [ cfg.accent ];
          variant = cfg.flavor;
        };
      };
    };
  };
}
