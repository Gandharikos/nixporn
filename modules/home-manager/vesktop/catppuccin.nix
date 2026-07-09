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
  source = pkgs.nixporn.catppuccin.discord;
  target = "vesktop";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}-${accent}.theme";
in
{
  config = lib.mkIf enable {
    programs.vesktop.vencord = {
      settings.enabledThemes = [ "${themeName}.css" ];
      themes.${themeName} = lib.fileContents "${source}/dist/${themeName}.css";
    };
  };
}
