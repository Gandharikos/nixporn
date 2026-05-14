{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  target = "freetube";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.freetube.settings = {
      baseTheme = "catppuccin${lib.toSentenceCase flavor}";
      mainColor = "Catppuccin${lib.toSentenceCase flavor}${lib.toSentenceCase accent}";
      secColor = "Catppuccin${lib.toSentenceCase flavor}${
        lib.toSentenceCase cfg.${target}.secondaryAccent
      }";
    };
  };
}
