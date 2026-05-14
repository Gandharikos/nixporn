{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "vesktop";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
  themeName = "${slug}.theme";
in
{
  config = lib.mkIf enable {
    programs.vesktop.vencord = {
      settings.enabledThemes = [ "${themeName}.css" ];
      themes.${themeName} = lib.fileContents "${source}/extras/discord/${slug}.css";
    };
  };
}
