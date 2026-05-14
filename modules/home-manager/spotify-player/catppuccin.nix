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
  target = "spotify-player";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.spotify-player = {
      settings.theme = "Catppuccin-${flavor}";
      inherit (lib.importTOML "${sources.spotify-player}/theme.toml") themes;
    };
  };
}
