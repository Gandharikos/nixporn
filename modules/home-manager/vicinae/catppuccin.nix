{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  target = "vicinae";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeConfiguration = {
    name = "catppuccin-${flavor}";
    iconTheme = "Catppuccin ${lib.toSentenceCase flavor} ${lib.toSentenceCase accent}";
  };
in
{
  config = lib.mkIf enable {
    programs.vicinae.settings.theme = {
      light = themeConfiguration;
      dark = themeConfiguration;
    };
  };
}
