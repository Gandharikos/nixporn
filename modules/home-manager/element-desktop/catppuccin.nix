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
  target = "element-desktop";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  theme = lib.importJSON "${sources.element}/${flavor}/${accent}.json";
in
{
  config = lib.mkIf enable {
    programs.element-desktop.settings = {
      default_theme = theme.name;
      setting_defaults.custom_themes = [ theme ];
    };
  };
}
