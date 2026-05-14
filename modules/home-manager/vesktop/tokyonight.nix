{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "vesktop";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
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
