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
  target = "atuin";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}-${accent}";
in
{
  config = lib.mkIf enable {
    programs.atuin.settings.theme.name = themeName;
    xdg.configFile."atuin/themes/${themeName}.toml".source =
      "${sources.atuin}/${flavor}/${themeName}.toml";
  };
}
