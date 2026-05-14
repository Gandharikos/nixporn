{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "halloy";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.halloy.settings.theme = "catppuccin-${flavor}";
    xdg.configFile."halloy/themes/catppuccin-${flavor}.toml".source =
      "${sources.halloy}/catppuccin-${flavor}.toml";
  };
}
