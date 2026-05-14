{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  target = "vesktop";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}-${accent}.theme";
in
{
  config = lib.mkIf enable {
    programs.vesktop.vencord = {
      settings.enabledThemes = [ "${themeName}.css" ];
      themes.${themeName} = ''
        @import url("https://catppuccin.github.io/discord/dist/${themeName}.css");
      '';
    };
  };
}
