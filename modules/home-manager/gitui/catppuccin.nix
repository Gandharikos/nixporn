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
  target = "gitui";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.gitui.theme = builtins.path {
      name = "catppuccin-${flavor}.ron";
      path = "${sources.gitui}/catppuccin-${flavor}.ron";
    };
  };
}
