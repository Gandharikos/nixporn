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
  target = "television";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}-${accent}";
in
{
  config = lib.mkIf enable {
    programs.television.settings.ui.theme = themeName;
    xdg.configFile."television/themes/${themeName}.toml".source =
      "${sources.television}/${themeName}.toml";
  };
}
