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
  target = "gtk";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  polarity = lib.toSentenceCase catppuccin.polarity;
in
{
  config = lib.mkIf enable {
    gtk.iconTheme = {
      name = "Papirus-${polarity}";
      package = pkgs.catppuccin-papirus-folders.override { inherit accent flavor; };
    };
  };
}
