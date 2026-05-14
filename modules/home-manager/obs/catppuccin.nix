{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "obs";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "Catppuccin-${lib.toSentenceCase flavor}.obt";
in
{
  config = lib.mkIf enable {
    xdg.configFile = {
      "obs-studio/themes/Catppuccin.obt".source = "${sources.obs}/Catppuccin.obt";
      "obs-studio/themes/${themeName}".source = "${sources.obs}/${themeName}";
    };
  };
}
