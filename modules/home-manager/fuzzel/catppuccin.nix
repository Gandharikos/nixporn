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
  target = "fuzzel";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fuzzel.settings.main.include = "${sources.fuzzel}/catppuccin-${flavor}/${accent}.ini";
  };
}
