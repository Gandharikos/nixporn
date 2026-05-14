{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor slug;
  sources = pkgs.nixporn.catppuccin;
  target = "bat";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "Catppuccin ${lib.toSentenceCase flavor}";
in
{
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = themeName;
      themes.${themeName} = {
        src = sources.bat;
        file = "${themeName}.tmTheme";
      };
    };
  };
}
