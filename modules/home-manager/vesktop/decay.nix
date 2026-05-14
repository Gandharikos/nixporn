{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.decay;
  target = "vesktop";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
  themeName = "decay.theme";
in
{
  config = lib.mkIf enable {
    programs.vesktop.vencord = {
      settings.enabledThemes = [ "${themeName}.css" ];
      themes.${themeName} = lib.fileContents "${sources.discord}/Decay.theme.css";
    };
  };
}
