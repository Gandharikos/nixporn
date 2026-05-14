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
  sources = pkgs.nixporn.catppuccin;
  target = "grub";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  theme = "${sources.grub}/src/catppuccin-${flavor}-grub-theme";
in
{
  config = lib.mkIf enable {
    boot.loader.grub = {
      font = "${theme}/font.pf2";
      splashImage = "${theme}/background.png";
      inherit theme;
    };
  };
}
